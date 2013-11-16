__proto = require "./__proto"
mongoose = require "mongoose"
Schema = mongoose.Schema


errorSchema = new Schema
#conmmon error fields
  type: String # type of error: transformation/extract/load
  message: String
  objType: String

  # transformation error fields
  subtype: String
  source_obj: String
  result_obj: [
    obj: String
    missing_fields: [String]
  ]


errorsSchema = new Schema
  batch_id: String
  company_id: String
  source_connection_id: String
  destination_connection_id: String
  batch_start: Date
  errors_count: Number
  errors_list: [errorSchema]


  # load/extract error fields

class Errors extends __proto("Errors", errorsSchema)

module.exports = Errors
