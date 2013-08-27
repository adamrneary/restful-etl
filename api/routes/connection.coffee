restify = require 'restify'
Connection = require('../../lib/db').models.Connection



module.exports =

  get: (req, res, next)->
    id = req.params.id
    Connection.findById id,  (err, connection) ->
      return next err if err?
      res.json connection

  post: (req, res, next)->
      json = req.body
      connection = new Connection json
      connection.save (err)->
        return next new restify.RestError(err) if err?
        res.json connection
