mongoose = require "mongoose"
_ = require "underscore"
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
  tenant_id: String
  source_connection_id: String
  destination_connection_id: String
  since: String
  updated_since: String
  jobs: [jobSchema]

class Batch extends __proto("Batch", batchSchema)
  create: (doc, cb, finishCb) =>
    super doc, (err, model) =>
      message model.tenant_id, "batch", {id: model?.id, err: err, status: "create"}
      if err
        cb err, model if cb
      else
        cb err, model if cb
        ETLBatch = require("../../batch").Batch
        newBatch = new ETLBatch model.toObject()
        jobsNames = []
        _.each model.jobs, (job) ->
          jobsNames.push job.object
        message model.tenant_id, "batch", {id: model?.id, jobs_names: jobsNames, err: err, status: "start"}
        newBatch.run (err) =>
          message model.tenant_id, "batch", {id: model?.id, err: err, status: "finish"}
          finishCb() if finishCb

  update: (id, doc, cb) ->
    super id, doc, (err, model) ->
      message model.tenant_id, "batch", {id: model?.id, err: err, status: "update"}
      cb err, model if cb

  destroy: (id, cb) ->
    super id, (err, model) ->
      message model.tenant_id, "batch", {id: model?.id, err: err, status: "destroy"}
      cb err, model if cb

module.exports = Batch
