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
        Line:[]
      @purchase = new Purchase(@companyId)


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
        source: 'QB:Purchase'
        qbd_id: '216'
        is_credit: true
        account_id: @accountLookup("QB:32")
        customer_id: @customerLookup("191") # entity could be customer or vendor
        transaction_date: "2013-03-14" # from TxnDate above
        period_id: @periodLookup("2013-03-14")
        amount_cents: 1500
      ,
        company_id: @companyId
        source: 'QB:Purchase'
        qbd_id: 'NG:1234'
        is_credit: false
        account_id: '09384509345Z'
        customer_id: @customerLookup("191") # entity could be customer or vendor
        product_id: '09384509345asd'
        transaction_date: "2013-03-14" # from TxnDate above
        period_id: @periodLookup("2013-03-14")
        amount_cents: 1000
      ,
        company_id: @companyId
        source: 'QB:Purchase'
        qbd_id: 'NG:3629083'
        is_credit: false
        account_id: '23482'
        customer_id: @customerLookup("191") # entity could be customer or vendor
        transaction_date: "2013-03-14" # from TxnDate above
        period_id: @periodLookup("2013-03-14")
        amount_cents: 500
      ]

      it 'logs a warning if AccountRef is not populated', ->

      it 'logs a warning if the total amount does not equal the sum of line amounts', ->
