async = require "async"
OAuth = require "oauth"
_ = require "underscore"
message = require("../../message").message
Errors = require "../../Errors"

maxResults = 500

exports.maxResults = (val) ->
  return maxResults unless val
  maxResults = val

exports.extract = (options = {}, cb) ->
  message options.tenant_id, "job status", {type: options?.type, batch_id: options?.batch?.options?._id, name: options?.object, err: null, status: "Retrieving #{options.object} data"}
  oauth = new OAuth.OAuth(
    "get_request_token url",
    "get_access_token url",
    options.oauth_consumer_key,
    options.oauth_consumer_secret,
    "1.0",
    "oob",
    "HMAC-SHA1",
    null,
    {"content-type": "text/plain", "Accept": "application/json", "Connection" : "close", "User-Agent" : "Node authentication"}
  )

  filter = ""
  if options.since
    filter = "where MetaData.CreateTime >= '#{options.since.format("YYYY-MM-DDTHH:MM:SSZ")}'"
    filter = filter.replace /\+/g, "%2B"
    filter = filter.replace /\=/g, "%3D"

  async.waterfall [
    # get the number of object
    (cb) ->
      if options.batch.stopped
        options.stopped = true
        cb()
        return
      oauth.getProtectedResource "https://qb.sbfinance.intuit.com/v3/company/#{options.realm}/query?query= select count(*) from #{options.object} #{filter}", "GET", options.oauth_access_key, options. oauth_access_secret,  (err, data, response) ->
        if err
          cb new Errors.IntuitExtractError("Response error", err)
          return
        data = JSON.parse(data)
        if data.QueryResponse
          count = data.QueryResponse.totalCount
          cb null, count
        else
          cb new Errors.IntuitExtractError("Response error", data)
    ,
    # get objects
    (count, cb) ->
      if options.batch.stopped
        options.stopped = true
        cb()
        return
      if count is 0
        cb null, []
      else
        # calculation the start position for each request
        startPositions = (start + 1 for start in [0..count] by maxResults)
        startPositions.pop() unless count % maxResults
        resultData = []
        async.each startPositions, (startPosition, cb)->
          if options.batch.stopped
            options.stopped = true
            cb()
            return
          oauth.getProtectedResource "https://qb.sbfinance.intuit.com/v3/company/#{options.realm}/query?query= select *, MetaData.CreateTime from #{options.object} #{filter} startposition #{startPosition} maxresults #{maxResults}", "GET", options.oauth_access_key, options. oauth_access_secret,  (err, data, response) ->
            if err
              cb new Errors.IntuitExtractError("Response error", err)
            else
              data = JSON.parse(data)
              if data.QueryResponse
                resultData = resultData.concat data.QueryResponse["#{options.object}"]
                cb()
              else
                cb new Errors.IntuitExtractError("Response error", data)
        , (err)->
          cb err, resultData
  ],
  (err, data) ->
    cb err, data if cb
