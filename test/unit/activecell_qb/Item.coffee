Item = require("../../../lib/load/providers/activecell_objects/qb/item").class
assert  = require("chai").assert

describe "qb ActiveCell", ->
  describe "item object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

      @qbdObj =
        Name: "Freight Reimbursement"
        Description: "Freight and Delivery Reimbursement"
        Active: true
        Taxable: false
        UnitPrice: 0
        Type: "Other Charge"
        IncomeAccountRef:
          value: "QB:119"
          name: "Reimbursed Freight & Delivery"
        AssetAccountRef:
          value: '456'
        ExpenseAccountRef:
          value: '123'
        COGSAccountRef:
          value: '234'
        DepositToAccountRef:
          value: '345'
        PurchaseCost: 0
        SalesTaxCodeRef:
          value: "QB:2"
          name: "Non"
        SpecialItem: false
        status: "Synchronized"
        Id: "QB:95"
        SyncToken: "1"
        MetaData:
          CreateTime: "2007-12-18T04:17:49Z"
          LastUpdatedTime: "2013-06-22T07:22:30Z"

      @item = new Item(@companyId)

      resultObj =
        company_id: @companyId
        qbd_id: 'QB:95'
        name: 'Freight Reimbursement'
        description: "Freight and Delivery Reimbursement"
        income_account_id: @accountLookup('QB:119')
        cogs_account_id: @accountLookup('234')
        expense_account_id: @accountLookup('123')
        asset_account_id: @accountLookup('456')
        deposit_account_id: @accountLookup('345')
        qb_type: 'Other Charge'