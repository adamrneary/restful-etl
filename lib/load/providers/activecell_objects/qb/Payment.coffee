_ = require "underscore"
Default = require("./default").Default
utils = require "./utils/utils"

class Payment extends Default
  constructor: (@company_id) ->
    @compareFields [
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

  transform: (qbdObj, extractData, loadData, loadResultData) =>
    result = []
    if qbdObj.DepositToAccountRef
      creditObj = _.clone qbdObj
      delete creditObj.DepositToAccountRef
      utils.transromRefs creditObj, extractData, loadData, loadResultData
      creditObj = super creditObj, extractData, loadData, loadResultData
      creditObj.amount_cents *= 100
      creditObj.source = "QB:Payment"
      creditObj.is_credit = true
      creditObj.period_id = creditObj.transaction_date
      creditObj.qbd_id += "-credit"
      result.push creditObj

      utils.transromRefs qbdObj, extractData, loadData, loadResultData
      qbdObj.account_id = qbdObj.deposit_account_id
      debitObj = super qbdObj, extractData, loadData, loadResultData
      debitObj.amount_cents *= 100
      debitObj.source = "QB:Payment"
      debitObj.is_credit = false
      debitObj.period_id = debitObj.transaction_date
      debitObj.qbd_id += "-debit"
      result.push debitObj
    else
      utils.transromRefs qbdObj, extractData, loadData, loadResultData
      obj = super qbdObj, extractData, loadData, loadResultData
      obj.amount_cents *= 100
      obj.source = "QB:Payment"
      obj.is_credit = true
      obj.period_id = obj.transaction_date
      result.push obj
    obj = result[0]
    _.each qbdObj.Line, (line) ->
      newObj = utils.lineTranform(line)
      newObj = _.defaults(newObj, obj)
      newObj.qbd_id = newObj.Id
      delete newObj.Id
      newObj.is_credit = false
      result.push newObj

    result

module.exports.class = Payment