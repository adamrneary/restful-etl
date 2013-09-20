__proto = require './__proto'
mongoose = require 'mongoose'
Schema = mongoose.Schema

jobSchema = new Schema
  extract:
    source_connection_id: String
    object: String
    grain: String
    since: String
    updated_since: String
  load:
    destination_connection_id: String
    object: String
    allowDelete: Boolean
    since: String

batchSchema = new Schema
  tenant_id: String
  source_connection_id: String
  destination_connection_id: String
  since: String
  updated_since: String
  jobs: [jobSchema]

scheduleSchema = new Schema
  tenant_id: String
  name: type: String
  frequency: String
  batches: [batchSchema]

class Schedule extends __proto('Schedule', scheduleSchema)

module.exports = Schedule
