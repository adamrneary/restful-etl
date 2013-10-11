_ = require "underscore"
extract = require "./extract/extract"
load = require "./load/load"

class Job
  constructor: (@options) ->

  extract: (cb) ->
    extract @options, (err, data) ->
      cb(err, data) if cb

  load: (cb) ->
    load @options, (err, data) ->
      cb(err, data) if cb

exports.Job = Job
