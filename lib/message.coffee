socket =require "./socket"

message = (tenantId, message, obj) ->
  console.log "tenantId: #{tenantId}, message: #{message}, obj: #{JSON.stringify(obj)}"
  socket.emit tenantId, message, obj if tenantId

module.exports.message = message