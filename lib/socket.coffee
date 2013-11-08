schedule = require "./schedule"
socketio = require "socket.io"

io = null
listen = (server) ->
  io = socketio.listen server
  io.configure "production", () ->
    io.set('log level', 1);

  io.sockets.on "connection", (socket) ->
    socket.on "subscribe", (data) ->
      socket.join data.tenant_id
      obj = schedule.findByTenantId(data.tenant_id)
      status = ""
      if obj then status = obj.status()
      else status = "doesn't exist"
      io.sockets.in(data.tenant_id).emit("schedule", status: status)
    socket.on "unsubscribe", (data) -> socket.leave data.tenant_id

emit = (room, eventName, data) ->
  return unless io
  io.sockets.in(room).emit(eventName, data)

module.exports.listen = listen
module.exports.emit = emit