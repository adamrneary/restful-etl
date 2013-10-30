mongoose = require 'mongoose'


module.exports = (name, schema)->

  Model = mongoose.model name, schema

  class __proto
# Return a list of all the instances the model can find
    index: (cb) ->
      Model.find {}, (err, docs) ->
        cb(err, docs)

# Creates a new instance in the database
    create: (doc, cb) ->
      model = new Model doc
      model.save (err)->
        cb(err, model)

# Show information about a single instance
    show: (id, cb)->
      Model.findById id, (err, doc) ->
        cb(err, doc)

# Update document with changes passed to doc
    update: (id, doc, cb)->
      Model.findByIdAndUpdate id, doc, (err, doc) ->
        cb(err, doc)

# Remove record from document
    destroy: (id, cb)->
      Model.findById id, (err, doc) ->
        if err
          cb(err, doc)
        else
          doc.remove (err) ->
            cb(err, doc)

    findOne: ->
      Model.findOne.apply Model, arguments

    find: ->
      Model.find.apply Model, arguments
