PurchaseOrder = require("../../../lib/load/providers/activecell_objects/qb/purchase_order").class
assert  = require("chai").assert

describe "qb ActiveCell", ->
  describe "purchaseOrder object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

      @qbdObj =
        VendorAddr:
          Id: "337"
          Line1: "Sylvester Brown"
          Line2: "33 Old Bayshore Rd"
          Line3: "Bayshore, CA  94326"
          Lat: "INVALID"
          Long: "INVALID"
        ShipAddr:
          Id: "338"
          Line1: "Larry's Landscaping & Garden Supply"
          Line2: "1045 Main Street"
          Line3: "Bayshore, CA 94326"
          Line4: "(415)  555-4567"
          Lat: "INVALID"
          Long: "INVALID"
        POStatus: "Open"
        domain: "QBO"
        sparse: false
        Id: "811"
        SyncToken: "1"
        MetaData:
          CreateTime: "2013-07-19T07:40:51-07:00"
          LastUpdatedTime: "2013-07-19T08:21:28-07:00"
        DocNumber: "1001"
        TxnDate: "2013-07-19"
        Line:[
          Id: "1"
          Description: "hose"
          Amount: 50.00
          DetailType: "ItemBasedExpenseLineDetail"
          ItemBasedExpenseLineDetail:
            CustomerRef:
              value: "110"
              name: "Adam's Candy Shop"
            BillableStatus: "NotBillable"
            ItemRef:
              value: "31"
              name: "Irrigation Hose"
            ClassRef:
              value: "100000000000128319"
              name: "Landscaping"
            UnitPrice: 50
            Qty: 1
            TaxCodeRef:
              value: "NON"
          AccountBasedExpenseLineDetail:
            AccountRef:
              value: "61"
              name: "Cost of Goods Sold"
        ]
        VendorRef:
          value: "24"
          name: "Brown Equipment Rental"
        APAccountRef:
          value: "38"
          name: "Accounts Payable"
        TotalAmt:50.00
      @purchaseOrder = new PurchaseOrder(@companyId)