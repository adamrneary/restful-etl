OAuth = require "oauth"
_ = require "underscore"

module.exports = (options = {}, cb) ->
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

  oauth.getProtectedResource "https://qb.sbfinance.intuit.com/v3/company/#{options.realm}/query?query= select *, MetaData.CreateTime from #{options.object} #{filter}", "GET", options.oauth_access_key, options. oauth_access_secret,  (err, data, response) ->
    data = JSON.parse(data).QueryResponse["#{options.object}"]
    data = [] if _.isUndefined(data)
    cb err, data if cb

