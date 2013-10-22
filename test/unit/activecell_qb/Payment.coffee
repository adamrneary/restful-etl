Item = require("../../../lib/load/providers/activecell_objects/qb/item").class
assert  = require("chai").assert

describe "qb ActiveCell", ->
  describe "item object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

    it 'can find a deposit account in the header', ->
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
        Line: [ ]

      @item = new Item(@companyId)

      resultObjs = [
        company_id: @companyId
        source: 'QB:Payment'
        qbd_id: 'NG:3410926-credit'
        is_credit: true
        account_id: @accountLookup("QB:4")
        customer_id: @customerLookup("QB:284")
        transaction_date: "2013-05-21" # from TxnDate above
        period_id: @periodLookup("2013-05-21")
        amount_cents: 4000
      ,
        company_id: @companyId
        source: 'QB:Payment'
        qbd_id: 'NG:3410926-debit'
        is_credit: false
        account_id: @accountLookup('QB:2')
        customer_id: @customerLookup("QB:284")
        transaction_date: "2013-05-21" # from TxnDate above
        period_id: @periodLookup("2013-05-21")
        amount_cents: 4000
      ]


    it 'can find deposit accounts in the lines', ->
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
        Line: [ ]

      @item = new Item(@companyId)

      # NOTE TO IGOR: Since we are unit testing the different types of lines,
      # maybe we should just stub the lines for these documents to save time.
      Lines: [
        Id: 'NG:1234'
        AccountId: '09384509345Z'
        Amount: 10
      ,
        Id: 'NG:3629083'
        AccountId: '23482'
        Amount: 20
      ]

      resultObjs = [
        company_id: @companyId
        source: 'QB:Payment'
        qbd_id: 'NG:3410926'
        is_credit: true
        account_id: @accountLookup("QB:4")
        customer_id: @customerLookup("QB:284")
        transaction_date: "2013-05-21" # from TxnDate above
        period_id: @periodLookup("2013-05-21")
        amount_cents: 4000
      ,
        company_id: @companyId
        source: 'QB:Payment'
        qbd_id: 'NG:1234'
        is_credit: false
        account_id: '09384509345Z'
        customer_id: @customerLookup("QB:284")
        transaction_date: "2013-05-21" # from TxnDate above
        period_id: @periodLookup("2013-05-21")
        amount_cents: 1000
      ,
        company_id: @companyId
        source: 'QB:Payment'
        qbd_id: 'NG:3629083'
        is_credit: false
        account_id: '23482'
        customer_id: @customerLookup("QB:284")
        transaction_date: "2013-05-21" # from TxnDate above
        period_id: @periodLookup("2013-05-21")
        amount_cents: 2000
      ]

      it 'logs a warning if AccountRef is not populated', ->

      it 'logs a warning if the total amount does not equal the sum of line amounts', ->
