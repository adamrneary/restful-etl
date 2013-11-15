_ = require "underscore"
Default = require("./default").Default
utils = require "../utils/utils"

class Payment extends Default
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
    @requiredFields [
      "account_id"
    ,
      "amount_cents"
    ]

  transform: (qbdObj, extractData, loadData, loadResultData, cb) =>
    messages = []
    result = []
    totalAmountCents = 0
    unless qbdObj.ARAccountRef
      messages.push
        subtype: "warning"
        message: "CustomerRef is not defined"
        objType: "Payment"
        source_obj: qbdObj
        result_obj: _.map result, (obj) =>
          obj: obj
          missing_fields: @_checkRequiredFields(obj)

    if qbdObj.DepositToAccountRef
      creditObj = _.clone qbdObj
      delete creditObj.DepositToAccountRef
      utils.transromRefs creditObj, extractData, loadData, loadResultData
      creditObj = super creditObj, extractData, loadData, loadResultData
      totalAmountCents = creditObj.amount_cents
      creditObj.amount_cents = Math.floor(creditObj.amount_cents * 100)
      creditObj.source = "QB:Payment"
      creditObj.is_credit = true
      creditObj.period_id = creditObj.transaction_date
      creditObj.qbd_id += "-credit"
      utils.satisfyDependencies(creditObj, extractData, loadData, loadResultData)
      result.push creditObj

      utils.transromRefs qbdObj, extractData, loadData, loadResultData
      qbdObj.account_id = qbdObj.deposit_account_id
      debitObj = super qbdObj, extractData, loadData, loadResultData
      debitObj.amount_cents = Math.floor(debitObj.amount_cents * 100)
      debitObj.source = "QB:Payment"
      debitObj.is_credit = false
      debitObj.period_id = debitObj.transaction_date
      debitObj.qbd_id += "-debit"
      utils.satisfyDependencies(debitObj, extractData, loadData, loadResultData)
      result.push debitObj
    else
      utils.transromRefs qbdObj, extractData, loadData, loadResultData
      obj = super qbdObj, extractData, loadData, loadResultData
      totalAmountCents = obj.amount_cents
      obj.amount_cents = Math.floor(obj.amount_cents * 100)
      obj.source = "QB:Payment"
      obj.is_credit = true
      obj.period_id = obj.transaction_date
      utils.satisfyDependencies(obj, extractData, loadData, loadResultData)
      result.push obj
    obj = result[0]
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

    unless _.all(result, (obj) => not @_checkRequiredFields(obj))
      messages.push
        subtype: "error"
        message: "required fields does not exist"
        objType: "Payment"
        source_obj: qbdObj
        result_obj: _.map result, (obj) =>
          obj: obj
          missing_fields: @_checkRequiredFields(obj)
      cb messages if cb
      return []

    if Math.floor(totalAmountCents)
      messages.push
        subtype: "warning"
        message: "total amount does not equal the sum of line amounts"
        objType: "Payment"
        source_obj: qbdObj
        result_obj: _.map result, (obj) =>
          obj: obj
          missing_fields: @_checkRequiredFields(obj)

    cb messages if cb

    result

module.exports.class = Payment