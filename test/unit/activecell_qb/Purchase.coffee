Purchase = require("../../../lib/load/providers/activecell_objects/qb/purchase").class
assert  = require("chai").assert

describe "qb ActiveCell", ->
  describe "purchase object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

      @qbdObj =
        AccountRef:
          value: "69"
          name: "Test Credit Card Account"
        PaymentType:"CreditCard"
        EntityRef:
          value: "191"
          name: "Sample Customer"
          type: "Customer"
        Credit: false
        TotalAmt: 15.00
        domain: "QBO"
        sparse: false
        Id: "216"
        SyncToken: "0"
        MetaData:
          CreateTime: "2013-03-14T14:13:37-07:00"
          LastUpdatedTime: "2013-03-14T14:13:37-07:00"
        DocNumber: "1234"
        TxnDate: "2013-03-14"
        PrivateNote: "This is the memo."
        Line:[
          Id: "1"
          Description: "Charge for advertising"
          Amount: 5.00
          DetailType: "AccountBasedExpenseLineDetail"
          AccountBasedExpenseLineDetail:
            ClassRef:
              value: "100100000000000212510"
              name: "Class 1"
            AccountRef:
              value: "8"
              name: "Advertising"
            BillableStatus:"Billable"
            MarkupInfo:
              Percent:10
            TaxCodeRef:
              value: "TAX"
          ,
          Id: "2"
          Description: "Charge for office supplies"
          Amount: 10.00
          DetailType: "ItemBasedExpenseLineDetail"
          ItemBasedExpenseLineDetail:
            BillableStatus: "Billable"
            ItemRef:
              value: "7"
              name: "Office Supplies 2"
            ClassRef:
              value: "100100000000000212510"
              name: "Class 1"
            UnitPrice:1
            MarkupInfo:
              Percent:1
            Qty:10,
            TaxCodeRef:
              value: "TAX"
          AccountBasedExpenseLineDetail:
            AccountRef:
              value: "9"
              name: "Bank Charges"
        ]
      @purchase = new Purchase(@companyId)