_ = require "underscore"
Default = require("./default").Default
utils = require "./utils/utils"

class Bill extends Default
  constructor: (@company_id) ->
    @compareFields [
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

  transform: (qbdObj, extractData, loadData, loadResultData) =>
    result = []
    utils.transromRefs qbdObj, extractData, loadData, loadResultData
    obj = super qbdObj, extractData, loadData, loadResultData
    obj.amount_cents *= 100
    obj.source = "QB:Bill"
    obj.is_credit = true
    obj.period_id = obj.transaction_date
    result.push obj
    _.each qbdObj.Line, (line) ->
      newObj = utils.lineTranform(line)
      newObj = _.defaults(newObj, obj)
      newObj.qbd_id = newObj.Id
      delete newObj.Id
      newObj.is_credit = false
      result.push newObj
      console.log "line", newObj

    result

module.exports.class = Bill

