__proto = require './__proto'
mongoose = require 'mongoose'
Schema = mongoose.Schema

tenantSchema = new Schema
  name: {type: String, required: true}

tenantSchema.pre 'save', (next)->
  Tenant::findOne {name: @name}, (err, data)->
    return next err if err
    return next new Error 'fields are not unique' if data?
    next()

class Tenant extends __proto('Tenant', tenantSchema)

module.exports = Tenant
