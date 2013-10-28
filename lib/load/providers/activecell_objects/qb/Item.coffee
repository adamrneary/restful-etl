_ = require "underscore"
Default = require("./utils/default").Default
utils = require "./utils/utils"

class Item extends Default
  constructor: (@company_id) ->
    @compareFields [
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

  transform: (qbdObj, extractData, loadData, loadResultData) =>
    result = []
    utils.transromRefs qbdObj, extractData, loadData, loadResultData
    obj = super qbdObj, extractData, loadData, loadResultData
    utils.satisfyDependencies(obj, extractData, loadData, loadResultData)
    obj


module.exports.class = Item