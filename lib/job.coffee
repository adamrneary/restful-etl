_ = require "underscore"
message = require("./message").message
extract = require "./extract/extract"
load = require "./load/load"

class Job
  constructor: (@options) ->

  run: (cb) ->
    message @options?.tenant_id, "job status", {type: @options?.type, batch_id: @options?.batch?.options?._id, name: @options?.object, err: null, status: "in process"} unless @options.object is "periods"

    switch @options.type
      when "extract"
        extract @options, (err, data) =>
          if @options.batch.stopped and not err
            message @options?.tenant_id, "job status", {type: @options?.type, batch_id: @options?.batch?.options?._id, name: @options?.object, err: err, status: "stopped"} unless @options.object is "periods"
          else
            message @options?.tenant_id, "job status", {type: @options?.type, batch_id: @options?.batch?.options?._id, name: @options?.object, err: err, status: "complete"} unless @options.object is "periods"
          cb(err, data) if cb
      when "load"
        load @options, (err) =>
          if @options.batch.stopped and not err
            message @options?.tenant_id, "job status", {type: @options?.type, batch_id: @options?.batch?.options?._id, name: @options?.object, err: err, status: "stopped"} unless @options.object is "periods"
          else
            message @options?.tenant_id, "job status", {type: @options?.type, batch_id: @options?.batch?.options?._id, name: @options?.object, err: err, status: "complete"} unless @options.object is "periods"
          cb(err) if cb

exports.Job = Job
