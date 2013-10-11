OAuth = require('oauth');

exports.extract = (options = {}, cb) ->
  oauth = new OAuth.OAuth(
    "get_request_token url",
    "get_access_token url",
    options.oauth_consumer_key,
    options.oauth_consumer_secret,
    '1.0',
    'oob',
    'HMAC-SHA1',
    null,
    {"Accept": "application/json", "Connection" : "close", "User-Agent" : "Node authentication"}
  )

  if options.since
    url = "https://api.xero.com/api.xro/2.0/#{options.object}?where=Date>=DateTime(#{options.since.year()},#{options.since.month()},#{options.since.day()})"
  else
    url = "https://api.xero.com/api.xro/2.0/#{options.object}"
  oauth.getProtectedResource url, "GET", options.oauth_access_key, options. oauth_access_secret,  (err, data, response) ->
    cb err, data if cb
