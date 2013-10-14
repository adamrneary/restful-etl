async = require "async"
_ = require "underscore"
connection = require "./db/models/connection"
extract = require "./extract/extract"
intuitBatchExtractor = require("./extract/providers/intuit_batch_extractor").extract
Job = require("./job").Job

class Batch
  constructor: (@options) ->
    @error = false
    @extractData = {}

  run: (cb) =>
    cb_success = _.after 2, cb
    @error = false
    connection::findOne {_id: @options.source_connection_id}, (err, connection) =>
      return if @error
      if err
        @error = true
        cb err if cb
      else
        unless connection
          @error = true
          cb new Error("source connection not found")  if cb
        else
          connectionObj = connection.toObject()
          if connectionObj.provider is "QBO_BATCH" or connectionObj.provider is "QBD_BATCH"
            intuitBatchExtractor @options, connectionObj, cb
          else
            @extractJobs = _.filter @options.jobs, (job) -> job.type is "extract"
            async.each @extractJobs, (job, cb) =>
              jobOptions = @_buildJobOptions _.clone(job), connectionObj, "extract"
              jobObj = new Job(jobOptions)
              jobObj.run (err, data) =>
                if err then cb(err)
                else
                  @extractData[jobOptions.object] = data
                  cb()
            , (err) =>
              return if @error
              if err
                @error = true
                cb(err) if cb
              else
                cb_success()

    connection::findOne {_id: @options.destination_connection_id}, (err, connection) =>
      return if @error
      if err
        cb err if cb
        @error = true
      else
        unless connection
          @error = true
          cb new Error("destination connection not found")  if cb
        else
          @loadJobs = _.filter @options.jobs, (job) -> job.type is "load"
          connectionObj = connection.toObject()
          async.each @loadJobs, (job, cb) =>
            jobOptions = @_buildJobOptions _.clone(job), connectionObj, "load"
            jobObj = new Job(jobOptions)
            jobObj.run (err) =>
              if err then cb(err)
              else
                cb()
          , (err) =>
            return if @error
            if err
              @error = true
              cb(err) if cb
            else
              cb_success()

  _buildJobOptions: (job, connection, type) ->
    jobOptions = {batch: @}
    jobOptions.provider = connection.provider
    switch jobOptions.provider.toUpperCase()
      when "QB"
        jobOptions.realm = connection.realm
        jobOptions.oauth_consumer_key = connection.oauth_consumer_key
        jobOptions.oauth_consumer_secret = connection.oauth_consumer_secret
        jobOptions.oauth_access_key = connection.oauth_access_key
        jobOptions.oauth_access_secret = connection.oauth_access_secret
      when "XERO"
        jobOptions.oauth_consumer_key = connection.oauth_consumer_key
        jobOptions.oauth_consumer_secret = connection.oauth_consumer_secret
        jobOptions.oauth_access_key = connection.oauth_access_key
        jobOptions.oauth_access_secret = connection.oauth_access_secret
      when "ACTIVECELL"
        jobOptions.companyId = connection.company_id
        jobOptions.subdomain = connection.subdomain
        jobOptions.username = connection.username
        jobOptions.password = connection.password

    _.extend jobOptions, job
    if @options.since
      jobOptions.since = @options.since if _.isUndefined jobOptions.since
    switch type
      when "extract"
        if @options.grain
          jobOptions.grain = @options.grain if _.isUndefined jobOptions.grain
#      when "load"

    jobOptions

exports.Batch = Batch
