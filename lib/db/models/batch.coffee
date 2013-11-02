mongoose = require "mongoose"
__proto = require "./__proto"

Schema = mongoose.Schema

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

class Batch extends __proto('Batch', batchSchema)
  create: (doc, cb) ->
    super doc, (err, model)->
      if err
        cb err, model
      else
        ETLBatch = require("../../batch").Batch
        newBatch = new ETLBatch doc
        newBatch.run (err) ->
#          console.log newBatch
          cb err, model

module.exports = Batch
