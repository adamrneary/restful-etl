Default = require("./utils/default").Default
utils = require "./utils/utils"

class Account extends Default
  constructor: (@company_id) ->
    @compareFields [
      activeCell: "qbd_id"
      qbd: "Id"
    ,
      activeCell: "name"
      qbd: "Name"
    ,
      activeCell: "type"
      qbd: "Classification"
    ,
      activeCell: "subtype"
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

  transform: (qbdObj, extractData, loadData, loadResultData) =>
    obj = super qbdObj, extractData, loadData, loadResultData
    utils.transromRefs obj, extractData, loadData, loadResultData

module.exports.class = Account

