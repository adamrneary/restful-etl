__proto = require "./__proto"
mongoose = require "mongoose"
Schema = mongoose.Schema

errorSchema = new Schema
  type: String # type of error: transformation/extract/load

  #conmmon error fields
  batch_id: String
  company_id: String
  source_connection_id: String
  destination_connection_id: String
  batch_start: Date
  message: String

  # transformation error fields
  subtype: String
  objType: String
  source_obj: String
  result_obj: [
    obj: String
    missing_fields: [String]
  ]

  # load/extract error fields

class Error extends __proto("Error", errorSchema)

module.exports = Error
