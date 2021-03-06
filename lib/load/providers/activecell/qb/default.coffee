_ = require "underscore"
class Default
  constructor: (@company_id) ->
    @transformFields [
      activeCell: "qbd_id"
      qbd: "Id"
    ,
      activeCell: "name"
      qbd: "DisplayName"
    ]
    @requiredFields []

  # transform  QBD object to ActiveCell object
  transform: (qbdObj, extractData, loadData, loadResultData) =>
    newObj = {company_id: @companyId()}
    _.each @transformFields(), (field) =>
      newObj[field.activeCell] = qbdObj[field.qbd] if qbdObj[field.qbd]
    newObj

  # get/set company id
  companyId: (newId) ->
    if _.isUndefined(newId) then @company_id
    else @company_id = newId

  # get/set compare fields
  transformFields: (newFields) ->
    if _.isArray(newFields) then @_transformFields = newFields
    else @_transformFields

  requiredFields: (newFields) ->
    if _.isArray(newFields) then @_requiredFields = newFields
    else @_requiredFields

  # return null if all required fields exists, otherwise list of fields
  _checkRequiredFields: (obj) ->
    requiredFields = @requiredFields()
    missingFields = _.filter requiredFields, (field) ->
      !obj[field]
    if missingFields.length then missingFields
    else null

exports.Default = Default
