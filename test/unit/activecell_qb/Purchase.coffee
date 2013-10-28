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
        TotalAmt: 2500
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
          Amount: 900
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
      resultObjs = [
        company_id: @companyId
        qbd_id: "216"
        account_id: "QB:69" #@accountLookup("QB:32")
        customer_id: "191" #@customerLookup("191") # entity could be customer or vendor
        transaction_date: "2013-03-14" # from TxnDate above
        amount_cents: 250000
        source: "QB:Purchase"
        is_credit: true
        period_id: "2013-03-14" #@periodLookup("2013-03-14")
      ,
        amount_cents: 90000
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

    it 'logs a warning if AccountRef is not populated', (done)->
      delete @qbdObj.AccountRef
      @purchase.transform(@qbdObj, null, null, null, (messages) ->
        assert.equal messages.length, 1
        assert.equal messages[0].type, "warning"
        done()
      )

    it 'logs a warning if the total amount does not equal the sum of line amounts', (done)->
      @qbdObj.TotalAmt = 32412
      @purchase.transform(@qbdObj, null, null, null, (messages) ->
        assert.equal messages.length, 1
        assert.equal messages[0].type, "warning"
        done()
      )
