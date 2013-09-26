OAuth = require('oauth');
module.exports = (options = {}, cb) ->
  oauth = new OAuth.OAuth(
    "get_request_token url",
    "get_access_token url",
    options.oauth_consumer_key,
    options.oauth_consumer_secret,
    '1.0',
    'oob',
    'HMAC-SHA1')

  switch options.provider.toUpperCase()
    when "QBD"
      oauth.getProtectedResource "https://services.intuit.com/sb/account/v2/#{options.realm}", "GET", options.oauth_access_key, options. oauth_access_secret,  (err, data, response) ->
#        console.log "error", err
#        console.log "data", data
        cb err, data if cb
    when "QBO"
      oauth.getProtectedResource "https://services.intuit.com/sb/account/v2/#{options.realm}", "GET", options.oauth_access_key, options. oauth_access_secret,  (err, data, response) ->
#        console.log "error", err
#        console.log "data", data
        cb err, data if cb




