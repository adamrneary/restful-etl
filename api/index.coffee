Error.stackTraceLimit = Infinity


fs = require("fs")
restify = require("restify")
routes = require("./routes")
middleware = require("../middleware")
formatters = require("./formatters")




#createServer:
server = restify.createServer
  name: 'etl-api'
  version: '0.0.1'
#  formatters:
#    "*/*": formatFoo = (req, res, body) ->
#      console.error body
#      return body.stack  if body instanceof Error
#      body.toString "base64"  if Buffer.isBuffer(body)



server.use restify.CORS()
server.use restify.authorizationParser()
server.use restify.acceptParser(server.acceptable)
server.use restify.dateParser()
server.use restify.queryParser()
server.use restify.jsonp()
server.use restify.gzipResponse()
server.use restify.bodyParser()



# ROUTES

server.get '/:model/:id', routes.get
server.post '/:model', routes.post


server.listen 7171, ->
  console.log "%s listening at %s", server.name, server.url


module.exports = server