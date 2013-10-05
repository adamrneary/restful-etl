async = require "async"
OAuth = require "oauth"
_ = require "underscore"

maxResults = 500

exports.maxResults = (val) ->
  return maxResults unless val
  maxResults = val

exports.extract = (options = {}, cb) ->
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
    (cb) ->
      oauth.getProtectedResource "https://qb.sbfinance.intuit.com/v3/company/#{options.realm}/query?query= select count(*) from #{options.object} #{filter}", "GET", options.oauth_access_key, options. oauth_access_secret,  (err, data, response) ->
        count = JSON.parse(data).QueryResponse?.totalCount
        count if _.isUndefined count
        cb err, count
    ,
    (count, cb) ->
      if count is 0
        cb null, []
      else
        startPositions = (start + 1 for start in [0..count] by maxResults)
        startPositions.pop() unless count % maxResults
        resultData = []
        async.each startPositions, (startPosition, cb2)->
          oauth.getProtectedResource "https://qb.sbfinance.intuit.com/v3/company/#{options.realm}/query?query= select *, MetaData.CreateTime from #{options.object} #{filter} startposition #{startPosition} maxresults #{maxResults}", "GET", options.oauth_access_key, options. oauth_access_secret,  (err, data, response) ->
            if err
              cb2 err
            else
              resultData = resultData.concat JSON.parse(data).QueryResponse["#{options.object}"]
              cb2 err
        , (err)->
          cb err, resultData
  ],
  (err, data) ->
#    fs = require('fs');
#    fs.writeFile "./test/data/#{options.object}", JSON.stringify(data), (err) ->
#      console.log "err", err
    cb err, data if cb
