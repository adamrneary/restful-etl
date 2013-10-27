CreditMemo = require("../../../lib/load/providers/activecell_objects/qb/CreditMemo").class
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

    it "can transform a qbdObj in order to create a new Activecell obj", ->
      resultObjs = [
        company_id: @companyId
        qbd_id: "276"
        account_id: "0969" #@accountLookup("0969")
        customer_id: "96" #@customerLookup("96")
        transaction_date: "2013-04-29" # from TxnDate above
        amount_cents: 1049895
        source: "QB:CreditMemo"
        is_credit: false
        period_id: "2013-04-29" #@periodLookup("2013-04-29")
      ,
        amount_cents: 50000
        product_id: "QB:345"
        account_id: "QB:678"
        company_id: @companyId
        qbd_id: 'QB:123'
        customer_id: "96" #@customerLookup("96")
        transaction_date: "2013-04-29" # from TxnDate above
        source: 'QB:CreditMemo'
        is_credit: true
        period_id: "2013-04-29" #@periodLookup("2013-04-29")
      ,
        amount_cents: 160000
        account_id: "QB:345"
        company_id: @companyId
        qbd_id: 'QB:213'
        customer_id: "96" #@customerLookup("96")
        transaction_date: "2013-04-29" # from TxnDate above
        source: 'QB:CreditMemo'
        is_credit: true
        period_id: "2013-04-29" #@periodLookup("2013-04-29")
      ]

      assert.deepEqual @creditMemo.transform(@qbdObj), resultObjs

    it 'logs a warning if the total amount does not equal the sum of line amounts', (done)->
      @creditMemo.transform(@qbdObj, null, null, null, (messages) ->
        assert.equal messages.length, 1
        assert.equal messages[0].type, "warning"
        done()
      )
