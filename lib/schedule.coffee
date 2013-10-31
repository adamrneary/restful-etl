_ = require "underscore"
async = require "async"
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
    CronJob = require('cron').CronJob
    @cronJob = new CronJob @options.cron_time, () =>
      @startCb() if @startCb
      unless @options.batches?.length
        @finishCb()
        return
      _.each @options.batches, (batchOptions) =>
        newBatch = new Batch(batchOptions)
        newBatch.run _.after @options.batches.length - 1, () =>
          @finishCb() @finishCb
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