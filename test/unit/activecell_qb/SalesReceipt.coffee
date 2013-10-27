SalesReceipt = require("../../../lib/load/providers/activecell_objects/qb/SalesReceipt").class
assert  = require("chai").assert

describe "qb ActiveCell", ->
  describe "salesReceipt object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

      @qbdObj =
        domain: "QBO"
        sparse: false
        Id: "97"
        SyncToken: "0"
        MetaData:
          CreateTime: "2013-03-13T13:31:43-07:00"
          LastUpdatedTime: "2013-03-13T13:31:43-07:00"
        DocNumber: "1047"
        TxnDate: "2013-03-13"
        CustomerRef:
          value: '239393'
        DepartmentRef:
          value: "1"
          name: "Department1"
        CurrencyRef:
          value: "USD"
          name: "United States Dollar"
        PrivateNote: "Memo for SalesReceipt"
        Line: [
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
        TxnTaxDetail: {"TotalTax": 0}
        TotalAmt: 5
        ApplyTaxAfterDiscount: false
        PrintStatus: "NeedToPrint"
        EmailStatus: "NotSet"
        Balance: 0
        DepositToAccountRef:
          value: "4"
          name: "Undeposited Funds"

      @salesReceipt = new SalesReceipt(@companyId)

      # NOTE TO IGOR: Since we are unit testing the different types of lines,
      # maybe we should just stub the lines for these documents to save time.
    it "can transform a qbdObj in order to create a new Activecell obj", ->
      Lines: [
        Id: 'NG:1234'
        AccountId: '09384509345Z'
        ProductId: '09384509345asd'
        Amount: 1
      ,
        Id: 'NG:3629083'
        AccountId: '23482'
        Amount: 4
      ]

      resultObjs = [
        company_id: @companyId
        qbd_id: "97"
        account_id: "4" #@accountLookup("4")
        customer_id: "239393" #@customerLookup("239393")
        transaction_date: "2013-03-13" # from TxnDate above
        amount_cents: 500
        source: "QB:SalesReceipt"
        is_credit: false
        period_id: "2013-03-13" #@periodLookup("2013-03-13")
      ,
        amount_cents: 50000
        product_id: "QB:345"
        account_id: "QB:678"
        company_id: @companyId
        qbd_id: "QB:123"
        customer_id: "239393" #@customerLookup("239393")
        transaction_date: "2013-03-13" # from TxnDate above
        source: "QB:SalesReceipt"
        is_credit: true
        period_id: "2013-03-13" #@periodLookup("2013-03-13")
      ,
        amount_cents: 160000
        account_id: "QB:345"
        company_id: @companyId
        qbd_id: "QB:213"
        customer_id: "239393" #@customerLookup("239393")
        transaction_date: "2013-03-13" # from TxnDate above
        source: "QB:SalesReceipt"
        is_credit: true
        period_id: "2013-03-13" #@periodLookup("2013-03-13")
      ]

      assert.deepEqual @salesReceipt.transform(@qbdObj), resultObjs
