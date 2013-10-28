_ = require "underscore"
Default = require("./default").Default
utils = require "../utils/utils"

class CreditMemo extends Default
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
    utils.transromRefs qbdObj, extractData, loadData, loadResultData
    qbdObj.account_id = qbdObj.deposit_account_id
    obj = super qbdObj, extractData, loadData, loadResultData
    obj.amount_cents *= 100
    obj.source = "QB:CreditMemo"
    obj.is_credit = false
    obj.period_id = obj.transaction_date
    utils.satisfyDependencies(obj, extractData, loadData, loadResultData)
    result.push obj
    totalAmountCents = obj.amount_cents
    _.each qbdObj.Line, (line) ->
      newObj = utils.lineTranform(line)
      newObj = _.defaults(newObj, obj)
      newObj.qbd_id = newObj.Id
      delete newObj.Id
      newObj.is_credit = true
      utils.satisfyDependencies(newObj, extractData, loadData, loadResultData)
      result.push newObj
      totalAmountCents -= newObj.amount_cents

    if totalAmountCents
      messages.push
        type: "warning"
        message: "total amount does not equal the sum of line amounts"

    cb messages if cb
    result

module.exports.class = CreditMemo