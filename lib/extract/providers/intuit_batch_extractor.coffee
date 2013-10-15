moment = require "moment"
async = require "async"
OAuth = require "oauth"
_ = require "underscore"
Errors = require "../../Errors"

maxResults = 500
maxBatchItems = 25

exports.maxResults = (val) ->
  return maxResults unless val
  maxResults = val

exports.maxBatchItems = (val) ->
  return maxBatchItems unless val
  maxBatchItems = val

exports.extract = (batch, connection, jobOptions, cb) ->
  oauth = new OAuth.OAuth(
    "get_request_token url",
    "get_access_token url",
    connection.oauth_consumer_key,
    connection.oauth_consumer_secret,
    "1.0",
    "oob",
    "HMAC-SHA1",
    null,
    {"content-type": "text/plain", "Accept": "application/json", "Connection" : "close", "User-Agent" : "Node authentication"}
  )

  globalError = false

  batchOperationsList = _.map jobOptions, (jobOpt) ->
    batchOperation = {startPosition: 1, _data: []}
    batchOperation.object = jobOpt.object

    since = jobOpt.since
    grain = jobOpt.grain
    filter = ""
    if since
      date = moment since
      switch jobOpt.grain
        when "monthly"
          date.month(0)
      filter = "where MetaData.CreateTime >= '#{date.format("YYYY-MM-DDTHH:MM:SSZ")}'"
    batchOperation.filter = filter
    batchOperation

  batchsStartPosition = (num for num in [0..batchOperationsList.length] by maxBatchItems)
  batchsStartPosition.pop() unless batchOperationsList.length % maxBatchItems

  batchsQueue = async.queue (data, cb) ->
    oauth.post "https://qb.sbfinance.intuit.com/v3/company/#{connection.realm}/batch", connection.oauth_access_key, connection.oauth_access_secret, data, "application/xml", (err, data, response) ->
      if err
        globalError = true
        cb new Errors.IntuitBatchExtractError "", err
        return

      data = JSON.parse(data).BatchItemResponse
      err = _.find data, (d)->
        d.Fault?.Error
      if err
        globalError = true
        cb new Errors.IntuitBatchExtractError JSON.stringify(err)
        return

      _.each data, (d)->
        batchOperationsList[d.bId]._data = batchOperationsList[d.bId]._data.concat d.QueryResponse["#{batchOperationsList[d.bId].object}"]
      cb()

  batchsQueue.drain = ()->
    return if globalError
    if (_.any batchOperationsList, (d)->
      if _.isUndefined d.totalCount
        return false
      else if d.startPosition < d.totalCount
        return false
      else
        return true

      )
      _.each batchOperationsList, (d) ->
        batch.extractData[d.object] = d._data
      cb null if cb

  createNewBatch = (last) ->
    resultsCount = 0
    itemsCount = 0
    result = "<IntuitBatchRequest xmlns='http://schema.intuit.com/finance/v3'>"
    _.each batchOperationsList, (d, i)->
      return if resultsCount >= maxResults
      return if itemsCount >= maxBatchItems
      return if _.isUndefined d.totalCount
      return if d.startPosition > d.totalCount
      count = Math.min(maxResults - resultsCount, d.totalCount - d.startPosition + 1)
      result += "<BatchItemRequest bId='#{i}'><Query>select *, MetaData.CreateTime from #{d.object} #{d.filter} startposition #{d.startPosition} maxresults #{count}</Query></BatchItemRequest>"
      d.startPosition += count
      resultsCount += count
      itemsCount++
    result += "</IntuitBatchRequest>"
    if resultsCount < maxResults and itemsCount > maxBatchItems and not last
      ""
    else if resultsCount is 0 and itemsCount is 0
      ""
    else
      result

  async.each batchsStartPosition, (batchStartPosition, cb)->
    data = "<IntuitBatchRequest xmlns='http://schema.intuit.com/finance/v3'>"
    for position in [batchStartPosition..Math.min(maxBatchItems + batchStartPosition - 1, batchOperationsList.length - 1)]
      data += "<BatchItemRequest bId='#{position}'><Query>select count(*) from #{batchOperationsList[position].object} #{batchOperationsList[position].filter}</Query></BatchItemRequest>"
    data += "</IntuitBatchRequest>"

    oauth.post "https://qb.sbfinance.intuit.com/v3/company/#{connection.realm}/batch", connection.oauth_access_key, connection.oauth_access_secret, data, "application/xml", (err, data, response) ->
      if err
        globalError = true
        cb new Errors.IntuitBatchExtractError "", err
        return

      data = JSON.parse(data).BatchItemResponse
      err = _.find data, (d)->
        d.Fault?.Error
      if err
        globalError = true
        cb new Errors.IntuitBatchExtractError JSON.stringify(err)
        return

      _.each data, (d)->
        batchOperationsList[d.bId].totalCount = d.QueryResponse.totalCount
      unless globalError
        batchsQueue.push newBatch while newBatch = createNewBatch()
      cb()
  ,
  (err)->
    if  err
      cb err if cb
    else
      batchsQueue.push newBatch while newBatch = createNewBatch(true)
      unless _.any(batchOperationsList, (d) -> d.totalCount)
        cb null if cb

