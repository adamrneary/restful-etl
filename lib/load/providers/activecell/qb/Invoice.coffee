_ = require "underscore"
Default = require("./default").Default
utils = require "../utils/utils"

class Invoice extends Default
  constructor: (@company_id) ->
    @transformFields [
      activeCell: "qbd_id"
      qbd: "Id"
    ,
      activeCell: "account_id"
      qbd: "account_id"
    ,
      activeCell: "customer_id"
      qbd: "customer_id"
    ,
      activeCell: "transaction_date"
      qbd: "TxnDate"
    ,
      activeCell: "amount_cents"
      qbd: "TotalAmt"
    ]

  transform: (qbdObj, extractData, loadData, loadResultData, cb) =>
    messages = []
    result = []
    unless qbdObj.CustomerRef
      messages.push
        type: "warning"
        message: "CustomerRef is not defined"

    unless qbdObj.Line and qbdObj.Line.length
       messages.push
         type: "warning"
         message: "there are no lines"

    utils.transromRefs qbdObj, extractData, loadData, loadResultData
    obj = super qbdObj, extractData, loadData, loadResultData
    obj.amount_cents *= 100
    obj.source = "QB:Invoice"
    obj.is_credit = true
    obj.period_id = obj.transaction_date
    totalAmountCents = obj.amount_cents
    utils.satisfyDependencies(obj, extractData, loadData, loadResultData)
    result.push obj
    _.each qbdObj.Line, (line) ->
      newObj = utils.lineTranform(line)
      newObj = _.defaults(newObj, obj)
      newObj.qbd_id = newObj.Id
      delete newObj.Id
      newObj.is_credit = false
      utils.satisfyDependencies(newObj, extractData, loadData, loadResultData)
      result.push newObj
      totalAmountCents -= newObj.amount_cents

    if totalAmountCents
      messages.push
        type: "warning"
        message: "total amount does not equal the sum of line amounts"

    cb messages if cb

    result

module.exports.class = Invoice