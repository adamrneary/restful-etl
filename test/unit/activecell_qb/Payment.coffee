Payment = require("../../../lib/load/providers/activecell_objects/qb/Payment").class
assert  = require("chai").assert

describe "qb ActiveCell", ->
  describe "Payment object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"
      @qbdObj =
        CustomerRef:
          value: "QB:284"
          name: "Google"
        RemitToRef:
          value: "QB:284"
          name: "Google"
        ARAccountRef:
          value: "QB:4"
          name: "Accounts Receivable"
        DepositToAccountRef:
          value: "QB:2"
          name: "Checking"
        PaymentMethodRef:
          value: "QB:9"
          name: "Home Depot Gift Card"
        PaymentRefNum:"Cash#003"
        TotalAmt: 40
        status: "Synchronized"
        Id: "NG:3410926"
        SyncToken: "6"
        MetaData:
          CreateTime: "2013-05-21T11:38:46Z"
          LastUpdatedTime: "2013-05-21T11:40:35Z"
        TxnDate: "2013-05-21"
        PrivateNote: "Testing with Cash and all fields mod"
        Line: [
          Id: "QB:213"
          Amount: 1600
          DetailType: "AccountBasedExpenseLineDetail"
          AccountBasedExpenseLineDetail:
            AccountRef: {value: "QB:345"}
        ,
          Id: "QB:212"
          Amount: 1612
          DetailType: "AccountBasedExpenseLineDetail"
          AccountBasedExpenseLineDetail:
            AccountRef: {value: "QB:31245"}
        ]

      @payment = new Payment(@companyId)

    it "can transform a qbdObj in order to create a new Activecell obj", ->
      resultObjs = [
        company_id: @companyId
        qbd_id: "NG:3410926-credit"
        account_id: "QB:4" #@accountLookup("QB:4")
        customer_id: "QB:284" #@customerLookup("QB:284")
        transaction_date: "2013-05-21" # from TxnDate above
        amount_cents: 4000
        source: "QB:Payment"
        is_credit: true
        period_id: "2013-05-21" #@periodLookup("2013-05-21")
      ,
        company_id: @companyId
        qbd_id: "NG:3410926-debit"
        account_id: "QB:2" #@accountLookup("QB:2")
        customer_id: "QB:284" #@customerLookup("QB:284")
        transaction_date: "2013-05-21" # from TxnDate above
        amount_cents: 4000
        source: "QB:Payment"
        is_credit: false
        period_id: "2013-05-21" #@periodLookup("2013-05-21")
      ,
        amount_cents: 160000
        account_id: "QB:345"
        company_id: @companyId
        qbd_id: "QB:213"
        customer_id: "QB:284" #@customerLookup("QB:284")
        transaction_date: "2013-05-21" # from TxnDate above
        source: "QB:Payment"
        is_credit: false
        period_id: "2013-05-21" #@periodLookup("2013-05-21")
      ,
        amount_cents: 161200
        account_id: "QB:31245"
        company_id: @companyId
        qbd_id: "QB:212"
        customer_id: "QB:284" #@customerLookup("QB:284")
        transaction_date: "2013-05-21" # from TxnDate above
        source: "QB:Payment"
        is_credit: false
        period_id: "2013-05-21" #@periodLookup("2013-05-21")
      ]

      assert.deepEqual @payment.transform(@qbdObj), resultObjs

      it 'logs a warning if AccountRef is not populated', ->

      it 'logs a warning if the total amount does not equal the sum of line amounts', ->
