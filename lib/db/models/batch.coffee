mongoose = require "mongoose"
_ = require "underscore"
errorsModel = require "./errors"
message = require("../../message").message
__proto = require "./__proto"
batch = require "../../batch"

Schema = mongoose.Schema

jobSchema = new Schema
  tenant_id: String
  type: {type: String, required: true}
  connection_id: String
  object: String
  grain: String
  since: String
  updated_since: String
  company_id: String
  required_objects:
    extract: [String]
    load: [String]
    load_result: [String]

batchSchema = new Schema
  tenant_id: String
  company_id: String
  source_connection_id: String
  destination_connection_id: String
  since: String
  updated_since: String
  created_at: Date
  finished_at: Date
  jobs: [jobSchema]

class Batch extends __proto("Batch", batchSchema)
  # Creates a new batch
  create: (doc, cb, finishCb) =>
    doc.created_at = new Date().toISOString()
    super doc, (err, model) =>
      message model?.tenant_id, "batch", {id: model?.id, err: err, status: "create"}
      if err
        cb err, model if cb
      else
        #creat and run batch if no errors
        cb err, model if cb
        newBatch = new batch.Batch model.toObject()
        jobsNames = []
        _.each model.jobs, (job) ->
          jobsNames.push job.object unless job.object is "periods"
        message model?.tenant_id, "batch", {id: model?.id, jobs_names: jobsNames, err: err, status: "start"}
        batch.addBatch newBatch
        newBatch.start (err) =>
          model.finished_at = new Date().toISOString()
          model.save()
          batch.deleteById model?.id
          message model?.tenant_id, "batch", {id: model?.id, err: err, status: "finish", finished_at: model.finished_at, created_at: model.create_at}
          if (_.keys newBatch.errors).length
            errors = []
            _.each _.values(newBatch.errors), (obj) ->
              errors = errors.concat obj.messages if obj.messages
            errorsModel::create
              batch_id: newBatch.id()
              company_id: newBatch.companyId
              source_connection_id: model.source_connection_id
              destination_connection_id: model.destination_connection_id
              batch_start: model.created_at
              errors_count: errors.length
              errors_list: errors

          finishCb() if finishCb

  # Update batch with changes passed to doc
  update: (id, doc, cb) ->
    super id, doc, (err, model) ->
      message model?.tenant_id, "batch", {id: model?.id, err: err, status: "update"}
      cb err, model if cb

  # Remove a batch
  destroy: (id, cb) ->
    super id, (err, model) ->
      message model?.tenant_id, "batch", {id: model?.id, err: err, status: "destroy"}
      cb err, model if cb

module.exports = Batch
