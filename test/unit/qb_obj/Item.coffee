Item = require("../../../lib/load/providers/activecell/qb/Item").class
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

      @loadData =
        accounts:
          [
            id: "17cc67093475061e3d95369d",
            qbd_id: "QB:119"
          ,
            id: "18cc6709347adfae3d95369d",
            qbd_id: "234"
          ,
            id: "19cc6709347adfae3d95369d",
            qbd_id: "123"
          ,
            id: "20cc6709347adfae3d95369d",
            qbd_id: "456"
          ,
            id: "21cc6709347adfae3d95369d",
            qbd_id: "345"
          ]

      @item = new Item(@companyId)

    it "can transform a qbdObj in order to create a new Activecell obj", ->
      resultObj =
        company_id: @companyId
        qbd_id: "QB:95"
        name: "Freight Reimbursement"
        description: "Freight and Delivery Reimbursement"
        income_account_id: "17cc67093475061e3d95369d" #@accountLookup("QB:119")
        cogs_account_id: "18cc6709347adfae3d95369d" #@accountLookup("234")
        expense_account_id: "19cc6709347adfae3d95369d" #@accountLookup("123")
        asset_account_id: "20cc6709347adfae3d95369d" #@accountLookup("456")
        deposit_account_id: "21cc6709347adfae3d95369d" #@accountLookup("345")
        qb_type: "Other Charge"

      assert.deepEqual @item.transform(@qbdObj, {}, @loadData, {}), resultObj
