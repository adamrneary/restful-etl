_ = require "underscore"
extract = require "./extract/extract"
load = require "./load/load"

class Job
  constructor: (@options) ->

  run: (cb) ->
    switch @options.type
      when "extract"
        extract @options, (err, data) ->
          cb(err, data) if cb
      when "load"
        load @options, (err) ->
          cb(err) if cb

exports.Job = Job
