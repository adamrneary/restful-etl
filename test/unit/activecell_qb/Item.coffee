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