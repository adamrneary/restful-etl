mongoose = require "mongoose"
Schema = mongoose.Schema
message = require("../../message").message
__proto = require "./__proto"

connectionSchema = new Schema
  tenant_id: String
  name: String
  provider: String
  realm: String
  oauth_consumer_key: String
  oauth_consumer_secret: String
  oauth_access_key: String
  oauth_access_secret: String

  subdomain: String
  company_id: String
  token: String

class Connection extends __proto("Connection", connectionSchema)
  create: (doc, cb) ->
    super doc, (err, model) ->
      message model.tenant_id, "connnection create", {id: model?.id, err: err}
      cb err, model if cb

  update: (id, doc, cb)->
    super id, doc, (err, model) ->
      message model.tenant_id, "connnection update", {id: model?.id, err: err}
      cb err, model if cb

  destroy: (id, cb)->
    super id, (err, model) ->
      message model.tenant_id, "connnection destroy", {id: model?.id, err: err}
      cb err, model if cb

module.exports = Connection
