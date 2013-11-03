async = require "async"
_ = require "underscore"
connection = require "./db/models/connection"
extract = require "./extract/extract"
intuitBatchExtractor = require("./extract/providers/intuit_batch_extractor").extract
Job = require("./job").Job
Errors = require "./Errors"

class Batch
  constructor: (@options) ->
    @error = false
    @extractData = {}
    @loadData = {}
    @loadResultData = {}

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
          cb new Errors.ConnectionError "source connection not found", @options.source_connection_id  if cb
        else
          connectionObj = connection.toObject()
          @extractJobs = _.filter @options.jobs, (job) -> job.type is "extract"
          jobOptions = _.map @extractJobs, (job) => @_buildJobOptions _.clone(job), connectionObj, "extract"
          if connectionObj.provider is "QB_BATCH" or connectionObj.provider is "QBD_BATCH"
            intuitBatchExtractor @, connectionObj, jobOptions, cb
          else
            async.each jobOptions, (jobOpt, cb) =>
              jobObj = new Job(jobOpt)
              jobObj.run (err, data) =>
                if err then cb(err)
                else
                  @extractData[jobOpt.object] = data
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
          connectionObj = connection.toObject()
          @loadJobs = _.filter @options.jobs, (job) -> job.type is "load"
          jobOptions = _.map @loadJobs, (job) => @_buildJobOptions _.clone(job), connectionObj, "load"
          async.each jobOptions, (jobOpt, cb) =>
            jobObj = new Job(jobOpt)
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
        jobOptions.token = connection.token

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
