__proto = require './__proto'
_ = require 'underscore'
mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema

schema = new Schema
  name: {type: String, required: true}
  realm: String
  oauth_consumer_key: String
  oauth_consumer_secret: String

schema.pre 'save', (next)->
  # TODO: add provider to the condition below
  Connection::findOne {name: @name}, (err, data)->
    console.log 'there'
    return next err if err
    return next new Error 'fields are not unique' if data?
    next()


class Connection extends __proto('Connection', schema)

module.exports = Connection
