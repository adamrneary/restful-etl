__proto = require './__proto'
mongoose = require 'mongoose'
Schema = mongoose.Schema


scheduleSchema = new Schema
  tenant_id: String
  name: type: String
  frequency: String

class Schedule extends __proto('Schedule', scheduleSchema)

module.exports = Schedule
