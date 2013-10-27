_ = require "underscore"

getIdByQBDId = (qbdId, list)->
  return "" unless list
  obj = _.find list, (d) ->
    d.qbd_id is qbdId
  if obj then obj.id
  else ""

getIdByQBOId = (qboId, list)->
  return "" unless list
  obj = _.find list, (d) ->
    d.qbo_id is qboId
  if obj then obj.id
  else ""

getIdByQBId = (qbId, list)->
  return "" unless list
  id = findIdByQBDId qbId, list
  return id if id
  findIdByQBOId qbId, list

getObjNameByQBName = (name) ->
  switch name
    when "Item" then "products"
    when "Bill", "CreditMemo", "Invoice", "Payment", "Purchase", "SalesReceipt" then "financial_txns"
    when "Account" then "accounts"
    when "Customer" then "customers"
    when "Vendor" then "vendors"

transromRefs = (obj) ->
  return unless obj
  keys = _.keys obj
  reg = /^(\w+)Ref$/
  _.each keys, (key)->
    return unless reg.test(key)
    entity =  reg.exec(key)[1]
    entity = obj[key].type if obj[key].type
    switch entity
      when "Parent"
        id = obj[key].value
        delete obj[key]
        obj.parent_qb_id = id
      when "Customer"
        id = obj[key].value
        delete obj[key]
        obj.CustomerId = id
      when "Vendor"
        id = obj[key].value
        delete obj[key]
        obj.VendorId = id

      else
        delete obj[key]
  obj

lineTranform = (obj, extractData, loadData, loadResultData) ->
  switch obj.DetailType
    when "AccountBasedExpenseLineDetail"
      newObj = {}
      newObj.Id = obj.Id
      newObj.Amount = obj.Amount
      newObj.AccountId = obj.AccountBasedExpenseLineDetail.AccountRef.value
    when "DepositLineDetail"
      newObj = {}
      newObj.Id = obj.Id
      newObj.Amount = obj.Amount
      newObj.AccountId = obj.DepositLineDetail.AccountRef.value
    when "DiscountLineDetail"
      newObj = {}
      newObj.Id = obj.Id
      newObj.Amount = obj.Amount
      newObj.AccountId = obj.DiscountLineDetail.Discount.DiscountAccountRef.value
    when "ItemBasedExpenseLineDetail"
      newObj = {}
      newObj.Id = obj.Id
      newObj.Amount = obj.Amount
      newObj.ProductId = obj.ItemBasedExpenseLineDetail.ItemRef.value
      if obj.ItemBasedExpenseLineDetail.ItemAccountRef
        newObj.AccountId = obj.ItemBasedExpenseLineDetail.ItemAccountRef.value
      else
        item = _.find extractData.Item, (item) ->
          item.Id is newObj.ProductId
        newObj.AccountId = item.ExpenseAccountRef.value
    when "JournalEntryLineDetail"
      newObj = {}
      newObj.Id = obj.Id
      newObj.Amount = obj.Amount
      newObj.PostingType = obj.JournalEntryLineDetail.PostingType
      newObj.AccountId = obj.JournalEntryLineDetail.AccountRef.value
      if obj.JournalEntryLineDetail.Entity.Type is "Vendor"
        newObj.VendorId = obj.JournalEntryLineDetail.Entity.EntityRef.value
      else
        newObj.VendorId = obj.JournalEntryLineDetail.Entity.EntityRef.value
    when "PaymentLineDetail"
      newObj = {}
      newObj.Id = obj.Id
      newObj.Amount = obj.Amount
      if obj.PaymentLineDetail.ItemRef
        newObj.ProductId = obj.PaymentLineDetail.ItemRef.value
        item = _.find extractData.Item, (item) ->
          item.Id is newObj.ProductId
        newObj.AccountId = item.DepositToAccountRef.value
      else
        newObj.AccountId = obj.PaymentLineDetail.Discount.DiscountAccountRef.value

    when "SalesItemLineDetail"
      newObj = {}
      newObj.Id = obj.Id
      newObj.Amount = obj.Amount
      newObj.ProductId = obj.SalesItemLineDetail.ItemRef.value
      if obj.SalesItemLineDetail.ItemAccountRef
        newObj.AccountId = obj.SalesItemLineDetail.ItemAccountRef.value
      else
        item = _.find extractData.Item, (item) ->
          item.Id is newObj.ProductId
        newObj.AccountId = item.IncomeAccountRef.value

  newObj


module.exports.getIdByQBDId = getIdByQBDId
module.exports.getIdByQBOId = getIdByQBOId
module.exports.getIdByQBId = getIdByQBId
module.exports.getObjNameByQBName = getObjNameByQBName
module.exports.transromRefs = transromRefs
module.exports.lineTranform = lineTranform
