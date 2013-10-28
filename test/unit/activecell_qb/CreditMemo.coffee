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
          Amount: 8898
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
        TotalAmt: 10498
        ApplyTaxAfterDiscount: false
        Balance:10498

      @loadData =
        accounts:
          [
            id: "17cc67093475061e3d95369d",
            qbd_id: "0969"
          ,
            id: "18cc6709347adfae3d95369d",
            qbd_id: "QB:678"
          ,
            id: "19cc6709347adfae3d95369d",
            qbd_id: "QB:345"
          ]
        customers:
          [
            id: "27cc67093475061e3d95369d",
            qbd_id: "96"
          ,
            id: "28cc6709347adfae3d95369d",
            qbd_id: "QB:165"
          ,
            id: "29cc6709347adfae3d95369d",
            qbd_id: "QB:166"
          ]
        products:
          [
            id: "37cc67093475061e3d95369d",
            qbd_id: "QB:345"
          ,
            id: "38cc6709347adfae3d95369d",
            qbd_id: "QB:365"
          ,
            id: "39cc6709347adfae3d95369d",
            qbd_id: "QB:366"
          ]
        periods:
          [
            id: "17cc67093475061e3d95369d",
            first_day: "2013-01-01"
          ,
            id: "27cc67093475061e3d95369d",
            first_day: "2013-02-01"
          ,
            id: "37cc67093475061e3d95369d",
            first_day: "2013-03-01"
          ,
            id: "37cc67093475061e3d95369d",
            first_day: "2013-04-01"
          ]

      @creditMemo = new CreditMemo(@companyId)

    it "can transform a qbdObj in order to create a new Activecell obj", ->
      resultObjs = [
        company_id: @companyId
        qbd_id: "276"
        account_id: "17cc67093475061e3d95369d" #@accountLookup("0969")
        customer_id: "27cc67093475061e3d95369d" #@customerLookup("96")
        transaction_date: "2013-04-29" # from TxnDate above
        amount_cents: 1049800
        source: "QB:CreditMemo"
        is_credit: false
        period_id: "37cc67093475061e3d95369d" #@periodLookup("2013-04-29")
      ,
        amount_cents: 889800
        product_id: "37cc67093475061e3d95369d"
        account_id: "18cc6709347adfae3d95369d"
        company_id: @companyId
        qbd_id: 'QB:123'
        customer_id: "27cc67093475061e3d95369d" #@customerLookup("96")
        transaction_date: "2013-04-29" # from TxnDate above
        source: 'QB:CreditMemo'
        is_credit: true
        period_id: "37cc67093475061e3d95369d" #@periodLookup("2013-04-29")
      ,
        amount_cents: 160000
        account_id: "19cc6709347adfae3d95369d"
        company_id: @companyId
        qbd_id: 'QB:213'
        customer_id: "27cc67093475061e3d95369d" #@customerLookup("96")
        transaction_date: "2013-04-29" # from TxnDate above
        source: 'QB:CreditMemo'
        is_credit: true
        period_id: "37cc67093475061e3d95369d" #@periodLookup("2013-04-29")
      ]

      assert.deepEqual @creditMemo.transform(@qbdObj, {}, @loadData, {}), resultObjs

    it 'logs a warning if the total amount does not equal the sum of line amounts', (done)->
      @qbdObj.TotalAmt = 32412
      @creditMemo.transform(@qbdObj, {}, @loadData, {}, (messages) ->
        assert.equal messages.length, 1
        assert.equal messages[0].type, "warning"
        done()
      )
