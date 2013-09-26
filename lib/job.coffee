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
    @options

  _buildLoadOptions: () ->

exports.Job = Job
