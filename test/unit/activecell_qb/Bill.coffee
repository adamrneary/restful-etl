Bill = require("../../../lib/load/providers/activecell_objects/qb/Bill").class
assert  = require("chai").assert

describe "qb ActiveCell", ->
  describe "bill object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

      @qbdObj =
          DueDate:"2013-02-15"
          Balance:1990.19,
          status:"Pending"
          Id: "NG:3424987"
          SyncToken: "1"
          MetaData:
            CreateTime: "2013-06-03T11:52:25Z"
            LastUpdatedTime: "2013-06-03T11:52:25Z"
          CustomField:[ ]
          DocNumber: "TEST001"
          TxnDate: "2013-02-05"
          PrivateNote: "tESTING with ll types of Line itesms"
          TxnStatus: "Payable"
          Line:[
            Id: "QB:123"
            Amount: 500
            DetailType: "ItemBasedExpenseLineDetail"
            ItemBasedExpenseLineDetail:
              ItemRef: {value: 'QB:345'}
              ItemAccountRef: {value: 'QB:678'}
          ]
          TxnTaxDetail:
            TaxLine: []
          VendorRef:
            value: "QB:164",
            name: "Bank of Anycity"
          APAccountRef:
            value: "QB:12",
            name: "Accounts Payable"
          TotalAmt:1990.19

      @bill = new Bill(@companyId)

    # NOTE TO IGOR: Since we are unit testing the different types of lines,
    # maybe we should just stub the lines for these documents to save time.
    it "can transform a qbdObj in order to create a new Activecell obj", ->
      Lines: [
        Id: 'NG:1234'
        AccountId: '09384509345Z'
        ProductId: '09384509345asd'
        Amount: 1000
      ,
        Id: 'NG:3629083'
        AccountId: '23482'
        Amount: 990.19
      ]

      resultObjs = [
        company_id: @companyId
        qbd_id: 'NG:3424987'
        account_id: "QB:12"#@accountLookup("QB:32")
        vendor_id: "QB:164"#@vendorLookup("QB:164")
        transaction_date: "2013-02-05" # from TxnDate above
        amount_cents: 199019
        source: 'QB:Bill'
        is_credit: true
        period_id: "2013-02-05"#@periodLookup("2013-02-05")
      ,
        amount_cents: 50000
        product_id: 'QB:345'
        account_id: 'QB:678'
        company_id: @companyId
        qbd_id: 'QB:123'
        vendor_id: "QB:164"#@vendorLookup("QB:164")
        transaction_date: "2013-02-05" # from TxnDate above
        source: 'QB:Bill'
        is_credit: false
        period_id: "2013-02-05"#@periodLookup("2013-02-05")
      ,
        company_id: @companyId
        source: 'QB:Bill'
        qbd_id: 'NG:3629083'
        is_credit: false
        account_id: '23482'
        vendor_id: "QB:164"#@vendorLookup("QB:164")
        transaction_date: "2013-02-05" # from TxnDate above
        period_id: "2013-02-05"#@periodLookup("2013-02-05")
        amount_cents: 99019
      ]

      assert.deepEqual @bill.transform(@qbdObj), resultObjs

    it 'logs a warning if the total amount does not equal the sum of line amounts', ->
