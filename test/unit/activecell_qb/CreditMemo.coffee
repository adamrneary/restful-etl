CreditMemo = require("../../../lib/load/providers/activecell_objects/qb/credit_memo").class
assert  = require("chai").assert

describe "qb ActiveCell", ->
  describe "creditMemo object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

      @qbdObj =
        domain: "QBO"
        Id: "276"
        SyncToken: "0"
        MetaData:
          CreateTime: "2013-04-29T17:30:30-07:00"
          LastUpdatedTime: "2013-04-29T17:30:30-07:00"
        DocNumber: "1139"
        TxnDate: "2013-04-29"
        Line:[]
        TxnTaxDetail:
          TxnTaxCodeRef:
            value: "9"
        TotalTax:1499.85
        TaxLine:[
          Amount:1499.85
          DetailType: "TaxLineDetail"
          TaxLineDetail:
            TaxRateRef:
              value:"8"
            PercentBased:true
            TaxPercent:15
            NetAmountTaxable:9999.00
        ]
        CustomerRef:
          value: "96"
          name: "yOvUlsnhx6 AOGcYnY5TI"
        DepositToAccountRef:
          value: "0969"
          name: 'checking'
        TotalAmt: 10498.95
        ApplyTaxAfterDiscount: false
        Balance:10498.95
      @creditMemo = new CreditMemo(@companyId)

      # NOTE TO IGOR: Since we are unit testing the different types of lines,
      # maybe we should just stub the lines for these documents to save time.
      Lines: [
        Id: '1235'
        AccountId: '09384509345Z'
        ProductId: '09384509345asd'
        Amount: 1000000
      ,
        Id: '3453'
        AccountId: '23482'
        Amount: 498.95
      ]

      resultObjs = [
        company_id: @companyId
        source: 'QB:CreditMemo'
        qbd_id: '276'
        is_credit: false
        account_id: @accountLookup("0969")
        customer_id: @customerLookup("96")
        transaction_date: "2013-04-29" # from TxnDate above
        period_id: @periodLookup("2013-04-29")
        amount_cents: 1049895
      ,
        company_id: @companyId
        source: 'QB:CreditMemo'
        qbd_id: '1235'
        is_credit: true
        account_id: '09384509345Z'
        customer_id: @customerLookup("96")
        product_id: '09384509345asd'
        transaction_date: "2013-04-29" # from TxnDate above
        period_id: @periodLookup("2013-04-29")
        amount_cents: 1000000
      ,
        company_id: @companyId
        source: 'QB:CreditMemo'
        qbd_id: '3453'
        is_credit: true
        account_id: '23482'
        customer_id: @customerLookup("96")
        transaction_date: "2013-04-29" # from TxnDate above
        period_id: @periodLookup("2013-04-29")
        amount_cents: 49895
      ]

    it 'logs a warning if the total amount does not equal the sum of line amounts', ->
