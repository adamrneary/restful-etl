_ = require 'underscore'
mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema

schema = new Schema
  name: {type: String, required: true}
#  provider: {type: ObjectId, ref: 'Provider'}
  realm: String
  oauth_consumer_key: String
  oauth_consumer_secret: String

schema.pre 'save', (next)->
  # TODO: add provider to the condition below
  Connection.findOne {name: @name}, (err, data)->
    return next err if err
    return next new Error 'fields are not unique' if data?
    next()


Connection = mongoose.model "Connection", schema




module.exports = Connection
