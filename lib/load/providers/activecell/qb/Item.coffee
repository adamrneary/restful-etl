_ = require "underscore"
Default = require("./default").Default
utils = require "../utils/utils"

class Item extends Default
  constructor: (@company_id) ->
    @transformFields [
      activeCell: "qbd_id"
      qbd: "Id"
    ,
      activeCell: "name"
      qbd: "Name"
    ,
      activeCell: "description"
      qbd: "Description"
    ,
      activeCell: "income_account_id"
      qbd: "income_account_id"
    ,
      activeCell: "cogs_account_id"
      qbd: "cogs_account_id"
    ,
      activeCell: "expense_account_id"
      qbd: "expense_account_id"
    ,
      activeCell: "asset_account_id"
      qbd: "asset_account_id"
    ,
      activeCell: "deposit_account_id"
      qbd: "deposit_account_id"
    ,
      activeCell: "qb_type"
      qbd: "Type"
    ]

  transform: (qbdObj, extractData, loadData, loadResultData, cb) =>
    messages = []
    result = []
    utils.transromRefs qbdObj, extractData, loadData, loadResultData
    obj = super qbdObj, extractData, loadData, loadResultData
    utils.satisfyDependencies(obj, extractData, loadData, loadResultData)
    result.push obj

    unless _.all(result, (obj) => @_checkRequiredFields(obj))
      messages.push
        type: "error"
        message: "required fields does not exist"
        objType: "Item"
        obj: qbdObj
      cb messages if cb
      return []

    cb messages if cb
    result

module.exports.class = Item