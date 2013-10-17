util = require "util"

AbstractError = (msg, constr) ->
  Error.captureStackTrace this, constr || this
  this.message = msg || "Error"
util.inherits AbstractError, Error
AbstractError.prototype.name = "Abstract Error"

DatabaseError = (msg) ->
  DatabaseError.super_.call this, msg, this.constructor
util.inherits(DatabaseError, AbstractError)
DatabaseError.prototype.name = "Database Error"

ConnectionError = (msg, id) ->
  ConnectionError.super_.call this, msg+": #{id}", this.constructor
util.inherits(ConnectionError, AbstractError)
ConnectionError.prototype.name = "Connection Error"

ConnectionError = (msg, id) ->
  ConnectionError.super_.call this, msg+": #{id}", this.constructor
util.inherits(ConnectionError, AbstractError)
ConnectionError.prototype.name = "Connection Error"

XeroExtractError = (msg, err) ->
  msg += "Errror: #{err.toString()}" if err
  XeroExtractError.super_.call this, msg, this.constructor
util.inherits(XeroExtractError, AbstractError)
XeroExtractError.prototype.name = "Xero Extract Error"

IntuitExtractError = (msg) ->
  IntuitExtractError.super_.call this, msg, this.constructor
util.inherits(IntuitExtractError, AbstractError)
IntuitExtractError.prototype.name = "Intuit Extract Error"

IntuitBatchExtractError = (msg) ->
  IntuitBatchExtractError.super_.call this, msg, this.constructor
util.inherits(IntuitBatchExtractError, AbstractError)
IntuitBatchExtractError.prototype.name = "Intuit Batch Extract Error"

IntuitLoadError = (msg) ->
  IntuitLoadError.super_.call this, msg, this.constructor
util.inherits(IntuitLoadError, AbstractError)
IntuitLoadError.prototype.name = "Intuit Load Error"



exports.AbstractError = AbstractError
exports.DatabaseError = DatabaseError
exports.ConnectionError = ConnectionError
exports.XeroExtractError = XeroExtractError
exports.IntuitExtractError = IntuitExtractError
exports.IntuitBatchExtractError = IntuitBatchExtractError
exports.IntuitLoadError = IntuitLoadError
