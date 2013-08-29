mongoose = require 'mongoose'


module.exports = (name, schema)->

  Model = mongoose.model name, schema

  class __proto
    getById: (id, cb)->
      Model.findById id,  (err, json) ->
        cb err, json

    append: (json, cb) ->
      model = new Model json
      model.save (err)->
        console.log 'saved', err
        cb(err, model)

    findOne: ->
      Model.findOne.apply Model, arguments

