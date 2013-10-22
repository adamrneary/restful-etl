SalesReceipt = require("../../../lib/load/providers/activecell_objects/qb/sales_receipt").class
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
        Line: []
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
        source: 'QB:SalesReceipt'
        qbd_id: '19'
        is_credit: false
        account_id: @accountLookup("4")
        customer_id: @customerLookup("239393")
        transaction_date: "2013-03-13" # from TxnDate above
        period_id: @periodLookup("2013-03-13")
        amount_cents: 500
      ,
        company_id: @companyId
        source: 'QB:SalesReceipt'
        qbd_id: 'NG:1234'
        is_credit: true
        account_id: '09384509345Z'
        customer_id: @customerLookup("239393")
        product_id: '09384509345asd'
        transaction_date: "2013-03-13" # from TxnDate above
        period_id: @periodLookup("2013-03-13")
        amount_cents: 100
      ,
        company_id: @companyId
        source: 'QB:SalesReceipt'
        qbd_id: 'NG:3629083'
        is_credit: true
        account_id: '23482'
        customer_id: @customerLookup("239393")
        transaction_date: "2013-03-13" # from TxnDate above
        period_id: @periodLookup("2013-03-13")
        amount_cents: 400
      ]

