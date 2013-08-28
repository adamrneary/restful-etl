restify = require 'restify'
models = require('../../lib/db').models

module.exports =

  get: (req, res, next)->
    id = req.params.id
    modelName = req.params.model[0].toUpperCase() + req.params.model.substring(1)
    models[modelName]::getById id,  (err, connection) ->
      return next err if err?
      res.json connection

  post: (req, res, next)->
    modelName = req.params.model[0].toUpperCase() + req.params.model.substring(1)
    json = req.body
    models[modelName]::append json, (err, model) ->
      return next new restify.RestError(err) if err?
      res.json model
