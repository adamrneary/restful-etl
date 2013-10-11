_ = require "underscore"
filter = (company_id, obj) ->
  company_id is obj.company_id and obj.qbd_id

compare = (company_id, qbdObj, activeCellObj) ->
  if (activeCellObj.company_id + activeCellObj.qbd_id) is (company_id + qbdObj.Id)
    if qbdObj.DisplayName is activeCellObj.name
      "equal"
    else
      "update"
  else
    ""

create = (company_id, qbdObj) ->
  newObj = {}
  newObj.company_id = company_id
  newObj.qbd_id = qbdObj.Id
  newObj.name = qbdObj.DisplayName
  newObj

update = (company_id, qbdObj, activeCellObj) ->
  _.extend activeCellObj, create(company_id, qbdObj)
  activeCellObj

exports.object =
  filter: filter
  compare: compare
  create: create
  update: update

