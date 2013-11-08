__proto = require "./__proto"
mongoose = require "mongoose"
Schema = mongoose.Schema

errorSchema = new Schema
  message: String
  qb_object_type: String
  qb_object: String

class Tenant extends __proto("Error", errorSchema)

module.exports = Tenant
