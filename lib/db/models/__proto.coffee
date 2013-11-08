mongoose = require 'mongoose'


module.exports = (name, schema)->

  Model = mongoose.model name, schema

  class __proto
# Return a list of all the instances the model can find
    index: (conditions, cb) ->
      conditions = {} unless conditions
      Model.find conditions, (err, docs) ->
        cb err, docs if cb

# Creates a new instance in the database
    create: (doc, cb) ->
      model = new Model doc
      model.save (err)->
        cb err, model if cb

# Show information about a single instance
    show: (id, cb)->
      Model.findById id, (err, doc) ->
        cb err, doc if cb

# Update document with changes passed to doc
    update: (id, doc, cb)->
      Model.findByIdAndUpdate id, doc, (err, doc) ->
        cb err, doc if cb

# Remove record from document
    destroy: (id, cb)->
      Model.findById id, (err, doc) ->
        if err
          cb err, doc if cb
        else
          doc.remove (err) ->
            cb err, doc if cb

    findOne: ->
      Model.findOne.apply Model, arguments

    find: ->
      Model.find.apply Model, arguments
