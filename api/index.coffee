Error.stackTraceLimit = Infinity

fs = require "fs"
restify = require "restify"
socket = require "../lib/socket"
routes = require "./routes"
exec = require("child_process").exec

#createServer:
server = restify.createServer
  name: "etl-api"
  version: "0.0.1"
  formatters:
    "*/*": formatFoo = (req, res, body) ->
      console.error body
      return body.stack  if body instanceof Error
      body.toString "base64"  if Buffer.isBuffer(body)

socket.listen server

server.use restify.CORS()
server.use restify.authorizationParser()
server.use restify.acceptParser(server.acceptable)
server.use restify.dateParser()
server.use restify.queryParser()
server.use restify.jsonp()
server.use restify.gzipResponse()
server.use restify.bodyParser()

# ROUTES
server.get "/:model/:id", routes.get
server.get "/:model", routes.get
server.post "/:model", routes.post
server.put "/:model/:id", routes.put
server.del "/:model/:id", routes.del

# Generate docco documenation
# TODO: This should be built into a deploy rake task of some sort rather than built when the server start up
exec "#{__dirname}/../node_modules/docco/bin/docco --output #{__dirname}/../showcase/source/src-docs --layout parallel #{__dirname}/../lib/db/models/*.coffee", (err, stdout, stderr) ->
  console.log("docco exec error: " + err || stderr) if err or stderr
#  console.log stdout.replace(/: ([\w|\/\.]*)/gm, '')

server.listen 7171, ->
  console.log "%s listening at %s", server.name, server.url

module.exports = server