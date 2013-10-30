_ = require "underscore"
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
    @cronJob = new CronJob '* * * * * *', () =>
      console.log "#{@options.name}"

  constructor: (@options) ->
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