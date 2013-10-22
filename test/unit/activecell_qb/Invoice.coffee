Invoice = require("../../../lib/load/providers/activecell_objects/qb/invoice").class
assert  = require("chai").assert

describe "qb ActiveCell", ->
  describe "invoice object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

      @qbdObj =
          status: "Synchronized"
          Id: "QB:64531"
          SyncToken: "1"
          MetaData:
            CreateTime: "2010-06-16T20:48:31.215Z"
            LastUpdatedTime: "2013-04-08T10:49:47Z"
          DocNumber: "1223"
          TxnDate: "2010-06-16"
          ExchangeRate: 1
          PrivateNote: "add grp and add an item in group dup 1214"
          TxnStatus: "Payable"
          TxnTaxDetail:
            DefaultTaxCodeRef:
              value: "QB:1"
              name: "Tax"
            TotalTax: 0
          CustomerRef:
            value: "QB:286"
            name: "General Electrical"
          RemitToRef:
            value: "QB:286"
            name: "General Electrical"
          DueDate: "2010-06-16"
          ShipMethodRef:
            value: "QB:4"
            name: "UPS"
          ShipDate: "2010-06-16"
          TotalAmt: 35
          TemplateRef:
            value: "QB:14"
            name: "Rock Castle Invoice"
          PrintStatus: "NotSet"
          EmailStatus: "NotSet"
          ARAccountRef:
            value: "QB:4"
            name: "Accounts Receivable"
          Balance: 35
          FinanceCharge: false

      @invoice= new Invoice(@companyId)


      # NOTE TO IGOR: Since we are unit testing the different types of lines,
      # maybe we should just stub the lines for these documents to save time.
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
        source: 'QB:Invoice'
        qbd_id: 'QB:64531'
        is_credit: true
        account_id: @accountLookup("QB:4")
        customer_id: @customerLookup("QB:286")
        transaction_date: "2010-06-16" # from TxnDate above
        period_id: @periodLookup("2010-06-16")
        amount_cents: 199019
      ,
        company_id: @companyId
        source: 'QB:Invoice'
        qbd_id: 'NG:1234'
        is_credit: false
        account_id: '09384509345Z'
        customer_id: @customerLookup("QB:286")
        product_id: '09384509345asd'
        transaction_date: "2010-06-16" # from TxnDate above
        period_id: @periodLookup("2010-06-16")
        amount_cents: 100000
      ,
        company_id: @companyId
        source: 'QB:Invoice'
        qbd_id: 'NG:3629083'
        is_credit: false
        account_id: '23482'
        customer_id: @customerLookup("QB:286")
        transaction_date: "2010-06-16" # from TxnDate above
        period_id: @periodLookup("2010-06-16")
        amount_cents: 99019
      ]

      it 'logs a warning if there are no lines', ->

      it 'logs a warning if CustomerRef is not populated', ->

      it 'logs a warning if the total amount does not equal the sum of line amounts', ->
