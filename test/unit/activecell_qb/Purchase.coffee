Purchase = require("../../../lib/load/providers/activecell_objects/qb/Purchase").class
assert  = require("chai").assert

describe "qb ActiveCell", ->
  describe "purchase object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

      @qbdObj =
        AccountRef:
          value: "QB:69"
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
          Id: "QB:123"
          Amount: 500
          DetailType: "ItemBasedExpenseLineDetail"
          ItemBasedExpenseLineDetail:
            ItemRef: {value: 'QB:345'}
            ItemAccountRef: {value: 'QB:678'}
        ,
          Id: "QB:213"
          Amount: 1600
          DetailType: "AccountBasedExpenseLineDetail"
          AccountBasedExpenseLineDetail:
            AccountRef: {value: "QB:345"}
        ]
      @purchase = new Purchase(@companyId)

    it "can transform a qbdObj in order to create a new Activecell obj", ->


      # NOTE TO IGOR: Since we are unit testing the different types of lines,
      # maybe we should just stub the lines for these documents to save time.
      Lines: [
        Id: 'NG:1234'
        AccountId: '09384509345Z'
        ProductId: '09384509345asd'
        Amount: 10.00
      ,
        Id: 'NG:3629083'
        AccountId: '23482'
        Amount: 5.00
      ]

      resultObjs = [
        company_id: @companyId
        qbd_id: "216"
        account_id: "QB:69" #@accountLookup("QB:32")
        customer_id: "191" #@customerLookup("191") # entity could be customer or vendor
        transaction_date: "2013-03-14" # from TxnDate above
        amount_cents: 1500
        source: "QB:Purchase"
        is_credit: true
        period_id: "2013-03-14" #@periodLookup("2013-03-14")
      ,
        amount_cents: 50000
        product_id: "QB:345"
        account_id: "QB:678"
        company_id: @companyId
        qbd_id: "QB:123"
        customer_id: "191" #@customerLookup("191") # entity could be customer or vendor
        transaction_date: "2013-03-14" # from TxnDate above
        source: "QB:Purchase"
        is_credit: false
        period_id: "2013-03-14" #@periodLookup("2013-03-14")
      ,
        amount_cents: 160000
        account_id: "QB:345"
        company_id: @companyId
        qbd_id: "QB:213"
        customer_id: "191" #@customerLookup("191") # entity could be customer or vendor
        transaction_date: "2013-03-14" # from TxnDate above
        source: "QB:Purchase"
        is_credit: false
        period_id: "2013-03-14" #@periodLookup("2013-03-14")
      ]

      assert.deepEqual @purchase.transform(@qbdObj), resultObjs

      it 'logs a warning if AccountRef is not populated', ->

      it 'logs a warning if the total amount does not equal the sum of line amounts', ->
