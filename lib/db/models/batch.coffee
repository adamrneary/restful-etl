mongoose = require "mongoose"
__proto = require "./__proto"

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

class Batch extends __proto('Batch', batchSchema)
  create: (doc, cb) ->
    super doc, (err, model)->
      batchConstructor = require("../../batch").Batch
      batch = new batchConstructor doc
      batch.run (err, jobs) ->
        console.log "jobs", jobs
        cb err, model

module.exports = Batch
