restify = require 'restify'
models = require('../../lib/db').models

module.exports =

  get: (req, res, next) ->
    id = req.params.id
    modelName = req.params.model[0].toUpperCase() + req.params.model.substring(1)
    conditions = req.query?.conditions
    conditions = JSON.parse(conditions) if conditions
    if id
      models[modelName]::show id, (err, doc) ->
        return next err if err?
        res.json doc
    else
      models[modelName]::index conditions, (err, docs) ->
        return next err if err?
        res.json docs

  post: (req, res, next) ->
    modelName = req.params.model[0].toUpperCase() + req.params.model.substring(1)
    doc = req.body
    models[modelName]::create doc, (err, doc) ->
      return next err if err?
      res.json doc

  put: (req, res, next) ->
    id = req.params.id
    modelName = req.params.model[0].toUpperCase() + req.params.model.substring(1)
    doc = req.body
    models[modelName]::update id, doc, (err, doc) ->
      return next err if err?
      res.json doc

  del: (req, res, next) ->
    id = req.params.id
    modelName = req.params.model[0].toUpperCase() + req.params.model.substring(1)
    models[modelName]::destroy id,  (err, doc) ->
      return next err if err?
      res.json doc
