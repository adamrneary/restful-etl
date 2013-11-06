_ = require "underscore"
class Default
  constructor: (@company_id) ->
    @compareFields ["qbd_id", "name"]

  # return true if we should use this object
  filter: (obj) ->
    @companyId() is obj.company_id and obj.qbd_id

  #Compare QBD and activeCellObj objects. Return:
  # "equal" - if the objects is equal
  # "update" - if the objects is not equal, and we should update the ActiveCell object
  # "" - if the objects can not be compared
  compare: (qbdObj, activeCellObj) ->
    if (activeCellObj.company_id + activeCellObj.qbd_id) is (@companyId() + qbdObj.qbd_id)
      equal = _.all @compareFields(), (field) ->
        activeCellObj[field] = null if _.isUndefined activeCellObj[field]
        qbdObj[field] = null if _.isUndefined qbdObj[field]
        unless qbdObj[field] is activeCellObj[field]
          console.log "#{field} qbdObj:#{qbdObj[field]} activeCellObj:#{activeCellObj[field]}"
#          console.log qbdObj
#          console.log activeCellObj
        qbdObj[field] is activeCellObj[field]
      if equal then "equal"
      else "update"
    else
      ""

  # update ActiveCell object using QB object
  update: (qbdObj, activeCellObj) ->
    activeCellObj = _.clone activeCellObj
    _.extend activeCellObj, qbdObj
    activeCellObj

  # get/set company id
  companyId: (newId) ->
    if _.isUndefined(newId) then @company_id
    else @company_id = newId

  # get/set compare fields
  compareFields: (newFields) ->
    if _.isArray(newFields) then @_compareFields = newFields
    else @_compareFields

exports.Default = Default
