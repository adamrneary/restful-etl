__proto = require './__proto'
mongoose = require 'mongoose'
Schema = mongoose.Schema
schedule = require "../../schedule"


jobSchema = new Schema
  type: {type: String, required: true}
  connection_id: String
  object: String
  grain: String
  since: String
  updated_since: String
  required_objects:
    extract: [String]
    load: [String]
    load_result: [String]

batchSchema = new Schema
  source_connection_id: String
  destination_connection_id: String
  since: String
  updated_since: String
  jobs: [jobSchema]

scheduleSchema = new Schema
  name: type: String
  frequency: String
  batches: [batchSchema]

class Schedule extends __proto('Schedule', scheduleSchema)
  create: (doc, cb) ->
    super doc, (err, model) ->
      unless err
        newSchedule = new schedule.Schedule(model)
        schedule.addSchedule newSchedule
        newSchedule.start()
      cb err, model
  destroy: (id, cb)->
    super id, (err, model) ->
      schedule.deleteById(id) unless err
      cb err, model

  update: (id, doc, cb)->
    super id, doc, (err, model) ->
      if err
        cb err, model
      else
        updateSchedule = schedule.findById(id)
        updateSchedule.update doc
        updateSchedule.start()
        cb err, model

module.exports = Schedule
