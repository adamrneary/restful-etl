_ = require "underscore"
class Default
  constructor: (@company_id) ->
    @compareFields[
      activeCell: "qbd_id"
      qbd: "Id"
      ,
      activeCell: "name"
      qbd: "DisplayName"
    ]

  # return true if we should use this object
  filter: (obj) ->
    @companyId() is obj.company_id and obj.qbd_id

  #Compare QBD and activeCellObj objects. Return:
  # "equal" - if the objects is equal
  # "update" - if the objects is not equal, and we should update the ActiveCell object
  # "" - if the objects can not be compared
  compare: (qbdObj, activeCellObj) ->
    if (activeCellObj.company_id + activeCellObj.qbd_id) is (@companyId() + qbdObj.Id)
      equal = _.all @compareFields(), (field) ->
        qbdObj[field.qbd] is activeCellObj[field.activeCell]
      if equal then "equal"
      else "update"
    else
      ""

  # transform  QBD object to ActiveCell object
  transform: (qbdObj) ->
    newObj = {company_id: @companyId()}
    _.each @compareFields(), (field) ->
      newObj[field.activeCell] = qbdObj[field.qbd]
    newObj

  # update ActiveCell object using QBD object
  update: (qbdObj, activeCellObj) ->
    _.extend activeCellObj, @transform(qbdObj)
    activeCellObj

  # get/set company id
  companyId: (newId) ->
    if _.isUndefined(newId) then @company_id
    else @company_id = newId

  # get/set compare fields
  compareFields: (newFields) ->
    if _.isArray(newFields) then @_compareFields
    else @_compareFields = newFields

exports.Default = Default
