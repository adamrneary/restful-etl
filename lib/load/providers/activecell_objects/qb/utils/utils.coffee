_ = require "underscore"

getIdByQBDId = (qbdId, list)->
  return "" unless list
  obj = _.find list, (d) ->
    d.qbd_id is qbdId
  if obj then obj.id
  else qbdId

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

satisfyDependencies = (obj, extractData, loadData, loadResultData) ->
  keys = _.keys obj
  _.each keys, (key)->
    switch key
      when "account_id"
        obj[key] = getIdByQBDId(obj[key], loadData.accounts)
      when "vendor_id"
        obj[key] = getIdByQBDId(obj[key], loadData.vendors)
      when "product_id"
        obj[key] = getIdByQBDId(obj[key], loadData.products)
      when "customer_id"
        obj[key] = getIdByQBDId(obj[key], loadData.customers)
      when "income_account_id"
        obj[key] = getIdByQBDId(obj[key], loadData.accounts)
      when "cogs_account_id"
        obj[key] = getIdByQBDId(obj[key], loadData.accounts)
      when "expense_account_id"
        obj[key] = getIdByQBDId(obj[key], loadData.accounts)
      when "asset_account_id"
        obj[key] = getIdByQBDId(obj[key], loadData.accounts)
      when "deposit_account_id"
        obj[key] = getIdByQBDId(obj[key], loadData.accounts)


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
        obj.customer_id = id
      when "Vendor"
        id = obj[key].value
        delete obj[key]
        obj.vendor_id = id
      when "APAccount"
        id = obj[key].value
        delete obj[key]
        obj.account_id = id
      when "ARAccount"
        id = obj[key].value
        delete obj[key]
        obj.account_id = id
      when "Account"
        id = obj[key].value
        delete obj[key]
        obj.account_id = id
      when "DepositToAccount"
        id = obj[key].value
        delete obj[key]
        obj.deposit_account_id = id
      when "IncomeAccount"
        id = obj[key].value
        delete obj[key]
        obj.income_account_id = id
      when "AssetAccount"
        id = obj[key].value
        delete obj[key]
        obj.asset_account_id = id
      when "ExpenseAccount"
        id = obj[key].value
        delete obj[key]
        obj.expense_account_id = id
      when "COGSAccount"
        id = obj[key].value
        delete obj[key]
        obj.cogs_account_id = id
      else
        delete obj[key]
  obj

lineTranform = (obj, extractData, loadData, loadResultData) ->
  switch obj.DetailType
    when "AccountBasedExpenseLineDetail"
      newObj = {}
      newObj.Id = obj.Id
      newObj.amount_cents = obj.Amount * 100
      newObj.account_id = obj.AccountBasedExpenseLineDetail.AccountRef.value
    when "DepositLineDetail"
      newObj = {}
      newObj.Id = obj.Id
      newObj.amount_cents = obj.Amount * 100
      newObj.account_id = obj.DepositLineDetail.AccountRef.value
    when "DiscountLineDetail"
      newObj = {}
      newObj.Id = obj.Id
      newObj.amount_cents = obj.Amount * 100
      newObj.account_id = obj.DiscountLineDetail.Discount.DiscountAccountRef.value
    when "ItemBasedExpenseLineDetail"
      newObj = {}
      newObj.Id = obj.Id
      newObj.amount_cents = obj.Amount * 100
      newObj.product_id = obj.ItemBasedExpenseLineDetail.ItemRef.value
      if obj.ItemBasedExpenseLineDetail.ItemAccountRef
        newObj.account_id = obj.ItemBasedExpenseLineDetail.ItemAccountRef.value
      else
        item = _.find extractData.Item, (item) ->
          item.Id is newObj.product_id
        newObj.account_id = item.ExpenseAccountRef.value
    when "JournalEntryLineDetail"
      newObj = {}
      newObj.Id = obj.Id
      newObj.amount_cents = obj.Amount * 100
      newObj.PostingType = obj.JournalEntryLineDetail.PostingType
      newObj.account_id = obj.JournalEntryLineDetail.AccountRef.value
      if obj.JournalEntryLineDetail.Entity.Type is "Vendor"
        newObj.vendor_id = obj.JournalEntryLineDetail.Entity.EntityRef.value
      else
        newObj.vendor_id = obj.JournalEntryLineDetail.Entity.EntityRef.value
    when "PaymentLineDetail"
      newObj = {}
      newObj.Id = obj.Id
      newObj.amount_cents = obj.Amount * 100
      if obj.PaymentLineDetail.ItemRef
        newObj.product_id = obj.PaymentLineDetail.ItemRef.value
        item = _.find extractData.Item, (item) ->
          item.Id is newObj.product_id
        newObj.account_id = item.DepositToAccountRef.value
      else
        newObj.account_id = obj.PaymentLineDetail.Discount.DiscountAccountRef.value

    when "SalesItemLineDetail"
      newObj = {}
      newObj.Id = obj.Id
      newObj.amount_cents = obj.Amount * 100
      newObj.product_id = obj.SalesItemLineDetail.ItemRef.value
      if obj.SalesItemLineDetail.ItemAccountRef
        newObj.account_id = obj.SalesItemLineDetail.ItemAccountRef.value
      else
        item = _.find extractData.Item, (item) ->
          item.Id is newObj.product_id
        newObj.account_id = item.IncomeAccountRef.value

  newObj


module.exports.getIdByQBDId = getIdByQBDId
module.exports.getIdByQBOId = getIdByQBOId
module.exports.getIdByQBId = getIdByQBId
module.exports.getObjNameByQBName = getObjNameByQBName
module.exports.transromRefs = transromRefs
module.exports.lineTranform = lineTranform
module.exports.satisfyDependencies = satisfyDependencies