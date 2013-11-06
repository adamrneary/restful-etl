_ = require "underscore"
Default = require("./default").Default
utils = require "../utils/utils"

class Account extends Default
  constructor: (@company_id) ->
    @transformFields [
      activeCell: "qbd_id"
      qbd: "Id"
    ,
      activeCell: "name"
      qbd: "Name"
    ,
      activeCell: "type"
      qbd: "Classification"
    ,
      activeCell: "sub_type"
      qbd: "AccountType"
    ,
      activeCell: "account_number"
      qbd: "AcctNum"
    ,
      activeCell: "current_balance"
      qbd: "CurrentBalance"
    ,
      activeCell: "ParentRef"
      qbd: "ParentRef"
    ]

    @requiredFields [
        "type"
    ]

  transform: (qbdObj, extractData, loadData, loadResultData, cb) =>
    messages = []
    result = []
    obj = super qbdObj, extractData, loadData, loadResultData
    obj.current_balance = Math.floor(obj.current_balance * 100) if obj.current_balance
    utils.transromRefs obj, extractData, loadData, loadResultData
    utils.satisfyDependencies(obj, extractData, loadData, loadResultData)
    result.push obj

    unless _.all(result, (obj) => @_checkRequiredFields(obj))
      messages.push
        type: "error"
        message: "required fields does not exist"
        obj: qbdObj

      cb messages if cb
      return []

    cb messages if cb
    result

module.exports.class = Account

