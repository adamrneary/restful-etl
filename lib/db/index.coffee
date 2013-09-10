mongoose = require "mongoose"
Schema = mongoose.Schema
config = require '../../config'

path = "mongodb://localhost:27017/#{config.db_path}"


conn = mongoose.connect path, (err, res) ->
  if err
    console.log "error", err
  else
    console.info "Succeeded connected to:", path

module.exports =
  conn: conn
  models:
    Connection: require("./models/connection")
    Batch: require("./models/batch")
    Schedule: require("./models/schedule")
    Tenant: require("./models/tenant")