_ = require "underscore"
async = require "async"
message = require("./message").message
Batch = require("./db/models/batch")
schedules = []


findById = (id) ->
  _.find schedules, (schedule) ->
    schedule.id() is id

findByTenantId = (id) ->
  _.find schedules, (schedule) ->
    schedule.tenant_id() is id

deleteById = (id) ->
  index = -1
  obj = _.find schedules, (schedule, i) ->
    index = i
    schedule?.id() is id
  if obj
    obj.stop()
    delete schedules[index]

addSchedule = (schedule) ->
  schedules.push schedule

class Schedule
  _createJob: () ->
    CronJob = require("cron").CronJob
    @cronJob = new CronJob @options.cron_time, () =>
      @status("runs")
      @startCb() if @startCb
      message @options?.tenant_id, "schedule", {id: @options.id, status: "start"}
      unless @options.batches?.length
        @finishCb() if @finishCb
        return
      errors = []
      _.each @options.batches, (batch) =>
        finishCb = _.after @options.batches.length - 1, () =>
          message @options?.tenant_id, "schedule", {id: @options.id, err: errors, status: "finish"}
          @status("queue")
          @finishCb() if @finishCb
        Batch::create(batch, (err) ->
          errors.push if err
        ,finishCb)
    , null, false, @options.timezone

  constructor: (@options, startCb, finishCb) ->
    _.each @options.batches, (batch) =>
      delete batch._id
      batch.tenant_id = @options.tenant_id
      _.each batch.jobs, (job) =>
        delete job._id
        job.tenant_id = @options.tenant_id
    @status("queue")
    @startCb = startCb if startCb
    @finishCb = finishCb if finishCb
    @_createJob()

  update: (@options) ->
    @cronJob.stop()
    @_createJob()

  id: () ->
    @options._id.toString()

  tenant_id: () ->
    @options.tenant_id

  status: (status) ->
    if _.isUndefined(status) then @_status
    else @_status = status

  start: () ->
    @cronJob.start()

  stop: () ->
    @cronJob.stop()

exports.Schedule = Schedule
exports.findById = findById
exports.findByTenantId = findByTenantId
exports.deleteById = deleteById
exports.addSchedule = addSchedule
