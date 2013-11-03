_ = require "underscore"
async = require "async"
message = require("./message").message
Batch = require("./batch").Batch
schedules = []


findById = (id) ->
  _.find schedules, (schedule) ->
    schedule.id() is id

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
      @startCb() if @startCb
      message @options.tenant_id, "schedule start", {id: @options.id} if @options.tenant_id
      unless @options.batches?.length
        @finishCb() if @finishCb
        return
      errors = []
      _.each @options.batches, (batchOptions) =>
        newBatch = new Batch(batchOptions)
        finishCb = _.after @options.batches.length - 1, () =>
          message @options.tenant_id, "schedule finish", {id: @options.id, err: errors} if @options.tenant_id
          @finishCb() if @finishCb
        newBatch.run (err) =>
          finishCb()
          errors.push err if err
    , null, false, @options.timezone

  constructor: (@options, startCb, finishCb) ->
    @startCb = startCb if startCb
    @finishCb = finishCb if finishCb
    @_createJob()

  update: (@options) ->
    @cronJob.stop()
    @_createJob()

  id: () ->
    @options._id.toString()

  start: () ->
    @cronJob.start()

  stop: () ->
    @cronJob.stop()

exports.Schedule = Schedule
exports.findById = findById
exports.deleteById = deleteById
exports.addSchedule = addSchedule