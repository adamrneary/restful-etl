_ = require "underscore"
mongoose = require "mongoose"
Schema = mongoose.Schema
config = require '../../config'
scheduleModel = require "./models/schedule"
schedule = require "../schedule"

path = config.db_path

conn = mongoose.connect path, (err, res) ->
  if err
    console.log "error", err
  else
    console.info "Succeeded connected to:", path

    #search and run all schedules
    scheduleModel::find {}, (err, docs) ->
      if err
        console.error "Get shudeles error:", err
      else
        _.each docs, (doc) ->
          newShedule = new schedule.Schedule doc.toObject()
          newShedule.start()
          schedule.addSchedule newShedule


module.exports =
  conn: conn
  models:
    Connection: require("./models/connection")
    Batch: require("./models/batch")
    Schedule: require("./models/schedule")
    Tenant: require("./models/tenant")