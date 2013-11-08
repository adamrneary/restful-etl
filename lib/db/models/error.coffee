__proto = require "./__proto"
mongoose = require "mongoose"
Schema = mongoose.Schema

errorSchema = new Schema
  type: String
  message: String
  objType: String
  source_obj: String
  result_obj: [
    obj: String
    missing_fields: [String]
  ]

class Tenant extends __proto("Error", errorSchema)

module.exports = Tenant
