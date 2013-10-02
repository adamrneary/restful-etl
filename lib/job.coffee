_ = require "underscore"
extract = require "./extract/extract"

class Job
  constructor: (@options) ->

  extract: (cb) ->
    extractOptions = @_buildExtractOptions()
    extract extractOptions, (err, data) ->
      cb(err, data) if cb

  load: (cb) ->
    cb() if cb

  _buildExtractOptions: () ->
    extractOptions = {}
    extractOptions.provider = @options.provider
    extractOptions.realm = @options.realm
    extractOptions.oauth_consumer_key = @options.oauth_consumer_key
    extractOptions.oauth_consumer_secret = @options.oauth_consumer_secret
    extractOptions.oauth_access_key = @options.oauth_access_key
    extractOptions.oauth_access_secret = @options.oauth_access_secret
    _.extend extractOptions, @options.extract
    extractOptions

  _buildLoadOptions: () ->
    loadOptions = {}
    loadOptions.provider = @options.provider
    loadOptions.oauth_consumer_key = @options.oauth_consumer_key
    loadOptions.oauth_consumer_secret = @options.oauth_consumer_secret
    loadOptions.oauth_access_key = @options.oauth_access_key
    loadOptions.oauth_access_secret = @options.oauth_access_secret
    _.extend loadOptions, @options.load
    loadOptions

exports.Job = Job
