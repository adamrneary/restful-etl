_ = require "underscore"
async = require "async"
message = require("./message").message
Batch = require("./db/models/batch")

schedules = [] #the list of running schedules

# find schedule by id
findById = (id) ->
  return null unless id
  _.find schedules, (schedule) ->
    schedule.id() is id

# find schedule by tenant id
findByTenantId = (id) ->
  return null unless id
  _.find schedules, (schedule) ->
    schedule.tenant_id() is id

# delete schedule by id
deleteById = (id) ->
  return unless id
  index = -1
  obj = _.find schedules, (schedule, i) ->
    index = i
    schedule?.id() is id
  if obj
    obj.stop()
    delete schedules[index]

# add schedule to the "schedules" list
addSchedule = (schedule) ->
  return unless schedule
  schedules.push schedule

class Schedule
  # create a cron job
  _createJob: () ->
    CronJob = require("cron").CronJob
    @cronJob = new CronJob @options.cron_time, () =>
      @status("runs") # set current status
      @startCb() if @startCb
      message @options?.tenant_id, "schedule", {id: @options.id, status: "start"}

      # exit if no batches
      unless @options.batches?.length
        @finishCb() if @finishCb
        return
      errors = [] # stores the errors for all batches
      _.each @options.batches, (batch) =>
        #create a function that will be called when all the batches will be compleated
        finishCb = _.after @options.batches.length - 1, () =>
          message @options?.tenant_id, "schedule", {id: @options.id, err: errors, status: "finish"}
          @status("queue") # set current status
          @finishCb() if @finishCb
        Batch::create(batch, (err) ->
          errors.push if err
        ,finishCb)
    , null, false, @options.timezone

  constructor: (@options, startCb, finishCb) ->
    _.each @options.batches, (batch) =>
      delete batch._id
      # set schedule id to batches and jobs
      batch.tenant_id = @options.tenant_id
      _.each batch.jobs, (job) =>
        delete job._id
        job.tenant_id = @options.tenant_id
    @status("queue") # set current status
    @startCb = startCb if startCb
    @finishCb = finishCb if finishCb
    @_createJob()

  # update a schedule
  update: (@options) ->
    @cronJob.stop() # stop current cron job
    @_createJob() # create new cron job

  # get schedule id
  id: () ->
    @options._id.toString()

  # get schedule tenant_id
  tenant_id: () ->
    @options.tenant_id

  # get/set current status
  status: (status) ->
    if _.isUndefined(status) then @_status
    else @_status = status

  # start a schedule
  start: () ->
    @cronJob.start()

  # stop a schedule
  stop: () ->
    @cronJob.stop()

exports.Schedule = Schedule
exports.findById = findById
exports.findByTenantId = findByTenantId
exports.deleteById = deleteById
exports.addSchedule = addSchedule
