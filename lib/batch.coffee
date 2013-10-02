_ = require "underscore"
connection = require "./db/models/connection"
extract = require "./extract/extract"
async = require "async"
Job = require("./job").Job

class Batch
  constructor: (@options) ->

  run: (cb) ->
    connection::findOne {_id: @options.source_connection_id}, (err, connection) =>
      if err
        cb err if cb
      else
        unless connection
          cb new Error("connection not found")  if cb
        else
          jobs = @options.jobs
          connectionObj = connection.toObject()
          async.each jobs, (job, cb) =>
            jobOptions = @_buildJobOptions _.clone(job), connectionObj
            jobObj = new Job(jobOptions)
            jobObj.extract (err, data) ->
              if err then cb(err)
              else
                job.extract._data = data if job.extract
                jobObj.load (err, data) ->
                  job.load._data = data if job.load
                  cb(err)
          , (err) ->
            if err
              cb(err) if cb
            else
              cb(err, jobs) if cb

  _buildJobOptions: (job, connection) ->
    jobOptions = {}
    jobOptions.provider = connection.provider
    jobOptions.realm = connection.realm
    jobOptions.oauth_consumer_key = connection.oauth_consumer_key
    jobOptions.oauth_consumer_secret = connection.oauth_consumer_secret
    jobOptions.oauth_access_key = connection.oauth_access_key
    jobOptions.oauth_access_secret = connection.oauth_access_secret

    _.extend jobOptions, job
    if @options.since
      jobOptions.extract?.since = @options.since unless jobOptions.extract?.since
      jobOptions.load?.since = @options.since unless jobOptions.load?.since
    if @options.grain
      jobOptions.extract?.grain = @options.grain unless jobOptions.extract?.grain
      jobOptions.load?.grain = @options.grain unless jobOptions.load?.grain
    jobOptions

exports.Batch = Batch
