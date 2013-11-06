moment = require "moment"
_ = require "underscore"

getIdByQBDId = (qbdId, list)->
  return qbdId unless list
  obj = _.find list, (d) ->
    d.qbd_id is qbdId
  if obj then obj.id
  else qbdId

getIdByQBOId = (qboId, list)->
  return qboId unless list
  obj = _.find list, (d) ->
    d.qbo_id is qboId
  if obj then obj.id
  else qboId

getIdByQBId = (qbId, list)->
  return qbId unless list
  id = getIdByQBDId qbId, list
  return id unless id is qbId
  getIdByQBOId qbId, list

getIdByDate = (date, list)->
  dateObj = moment date
  dateObj.date(1)
  findStr = dateObj.format('YYYY-MM-DD');
  obj = _.find list, (d) ->
    d.first_day is findStr
  if obj then obj.id
  else date

getObjNameByQBName = (name) ->
  switch name
    when "Item" then "products"
    when "Bill", "CreditMemo", "Invoice", "Payment", "Purchase", "SalesReceipt" then "financial_transactions"
    when "Account" then "accounts"
    when "Customer" then "customers"
    when "Vendor" then "vendors"

getQBObjByObjName = (name) ->
  switch name
    when "products" then ["Item"]
    when  "financial_transactions" then ["Bill", "CreditMemo", "Invoice", "Payment", "Purchase", "SalesReceipt"]
    when "accounts" then ["Account"]
    when "customers" then ["Customer"]
    when "vendors" then ["Vendor"]
    when "periods" then []

satisfyDependencies = (obj, extractData, loadData, loadResultData) ->
  result = false
  keys = _.keys obj
  _.each keys, (key)->
    switch key
      when "account_id", "income_account_id", "cogs_account_id", "expense_account_id", "asset_account_id", "deposit_account_id", "parent_account_id"
        if loadResultData.accounts
          newValue = getIdByQBId(obj[key], loadResultData.accounts)
        else
          newValue = getIdByQBId(obj[key], loadData.accounts)
        result = true unless obj[key] is newValue
        obj[key] = newValue
      when "vendor_id"
        if loadResultData.vendors
          newValue = getIdByQBId(obj[key], loadResultData.vendors)
        else
          newValue = getIdByQBId(obj[key], loadData.vendors)
        result = true unless obj[key] is newValue
        obj[key] = newValue
      when "product_id"
        if loadResultData.products
          newValue = getIdByQBId(obj[key], loadResultData.products)
        else
          newValue = getIdByQBId(obj[key], loadData.products)
        result = true unless obj[key] is newValue
        obj[key] = newValue
      when "customer_id"
        if loadResultData.customers
          newValue = getIdByQBId(obj[key], loadResultData.customers)
        else
          newValue = getIdByQBId(obj[key], loadData.customers)
        result = true unless obj[key] is newValue
        obj[key] = newValue
      when "period_id"
        if loadResultData.customers
          newValue = getIdByDate(obj[key], loadResultData.periods)
        else
          newValue = getIdByDate(obj[key], loadData.periods)
        result = true unless obj[key] is newValue
        obj[key] = newValue
  result

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
        obj.parent_account_id = id
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
        newObj.account_id = item?.ExpenseAccountRef.value
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
        newObj.account_id = item?.DepositToAccountRef.value
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
        newObj.account_id = item?.IncomeAccountRef.value

  newObj


module.exports.getIdByQBDId = getIdByQBDId
module.exports.getIdByQBOId = getIdByQBOId
module.exports.getIdByQBId = getIdByQBId
module.exports.getObjNameByQBName = getObjNameByQBName
module.exports.transromRefs = transromRefs
module.exports.lineTranform = lineTranform
module.exports.satisfyDependencies = satisfyDependencies
module.exports.getQBObjByObjName = getQBObjByObjName