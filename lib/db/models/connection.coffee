__proto = require './__proto'
mongoose = require 'mongoose'
Schema = mongoose.Schema

connectionSchema = new Schema
  name: {type: String, required: true}
  provider: String
  realm: String
  oauth_consumer_key: String
  oauth_consumer_secret: String

connectionSchema.pre 'save', (next)->
  Connection::findOne {name: @name}, (err, data)->
    return next err if err
    return next new Error 'fields are not unique' if data?
    next()

class Connection extends __proto('Connection', connectionSchema)

module.exports = Connection
