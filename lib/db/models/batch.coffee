mongoose = require "mongoose"
message = require("../../message").message
__proto = require "./__proto"

Schema = mongoose.Schema

jobSchema = new Schema
  tenant_id: String
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

class Batch extends __proto("Batch", batchSchema)
  create: (doc, cb) =>
    super doc, (err, model) =>
      message model.tenant_id, "batch create", {id: model?.id, err: err}
      if err
        cb err, model if cb
      else
        ETLBatch = require("../../batch").Batch
        newBatch = new ETLBatch doc
        message model.tenant_id, "batch start", {id: model?.id, err: err}
        newBatch.run (err) =>
          message model.tenant_id, "batch finish", {id: model?.id, err: err}
          cb err, model if cb
          @destroy model.id


  update: (id, doc, cb)->
    super id, doc, (err, model) ->
      message model.tenant_id, "batch update", {id: model?.id, err: err}
      cb err, model if cb

  destroy: (id, cb)->
    super id, (err, model) ->
      message model.tenant_id, "batch destroy", {id: model?.id, err: err}
      cb err, model if cb

module.exports = Batch
