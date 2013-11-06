_ = require "underscore"
Default = require("./default").Default
utils = require "../utils/utils"

class Bill extends Default
  constructor: (@company_id) ->
    @transformFields [
      activeCell: "qbd_id"
      qbd: "Id"
    ,
      activeCell: "account_id"
      qbd: "account_id"
    ,
      activeCell: "vendor_id"
      qbd: "vendor_id"
    ,
      activeCell: "transaction_date"
      qbd: "TxnDate"
    ,
      activeCell: "amount_cents"
      qbd: "TotalAmt"
    ]
    @requiredFields [
      "account_id"
    ,
      "amount_cents"
    ]


  transform: (qbdObj, extractData, loadData, loadResultData, cb) =>
    messages = []
    result = []
    utils.transromRefs qbdObj, extractData, loadData, loadResultData
    obj = super qbdObj, extractData, loadData, loadResultData
    totalAmountCents = obj.amount_cents
    obj.amount_cents = Math.floor(obj.amount_cents * 100)
    obj.source = "QB:Bill"
    obj.is_credit = true
    obj.period_id = obj.transaction_date
    utils.satisfyDependencies(obj, extractData, loadData, loadResultData)
    result.push obj
    totalAmountCents = obj.amount_cents
    _.each qbdObj.Line, (line) ->
      newObj = utils.lineTranform(line)
      totalAmountCents -= newObj.amount_cents
      newObj.amount_cents = Math.floor(newObj.amount_cents * 100)
      newObj = _.defaults(newObj, obj)
      newObj.qbd_id = newObj.Id
      delete newObj.Id
      newObj.is_credit = false
      utils.satisfyDependencies(newObj, extractData, loadData, loadResultData)
      result.push newObj

    unless _.all(result, (obj) => @_checkRequiredFields(obj))
      messages.push
        type: "error"
        message: "required fields does not exist"
        objType: "Bill"
        obj: qbdObj
      cb messages if cb
      return []

    if Math.floor(totalAmountCents)
      messages.push
        type: "warning"
        message: "total amount does not equal the sum of line amounts"
        objType: "Bill"
        obj: qbdObj

    cb messages if cb
    result

module.exports.class = Bill

