mongoose = require "mongoose"
Schema = mongoose.Schema
message = require("../../message").message
__proto = require "./__proto"

connectionSchema = new Schema
  company_id: String
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
  # Creates a new connection
  create: (doc, cb) ->
    super doc, (err, model) ->
      message model?.tenant_id, "connnection", {id: model?.id, err: err, status: "create"}
      cb err, model if cb

  # Update connection with changes passed to doc
  update: (id, doc, cb)->
    super id, doc, (err, model) ->
      message model?.tenant_id, "connnection", {id: model?.id, err: err, status: "update"}
      cb err, model if cb

  # Remove a connection
  destroy: (id, cb)->
    super id, (err, model) ->
      message model?.tenant_id, "connnection", {id: model?.id, err: err, status: "destroy"}
      cb err, model if cb

module.exports = Connection
