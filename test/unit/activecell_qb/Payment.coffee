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
        TotalAmt: 4000
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
          Amount: 2400
          DetailType: "AccountBasedExpenseLineDetail"
          AccountBasedExpenseLineDetail:
            AccountRef: {value: "QB:31245"}
        ]

      @loadData =
        accounts:
          [
            id: "17cc67093475061e3d95369d",
            qbd_id: "QB:4"
          ,
            id: "18cc6709347adfae3d95369d",
            qbd_id: "QB:2"
          ,
            id: "19cc6709347adfae3d95369d",
            qbd_id: "QB:345"
          ,
            id: "16cc6709347adfae3d95369d",
            qbd_id: "QB:31245"
          ]
        customers:
          [
            id: "27cc67093475061e3d95369d",
            qbd_id: "QB:284"
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
            id: "37cc67093475061e3d95369d",
            first_day: "2013-03-01"
          ,
            id: "36cc67093475061e3d95369d",
            first_day: "2013-04-01"

            id: "17cc67093475061e3d95369d",
            first_day: "2013-05-01"
          ,
            id: "27cc67093475061e3d95369d",
            first_day: "2013-06-01"
          ]

      @payment = new Payment(@companyId)

    it "can transform a qbdObj in order to create a new Activecell obj", ->
      resultObjs = [
        company_id: @companyId
        qbd_id: "NG:3410926-credit"
        account_id: "17cc67093475061e3d95369d" #@accountLookup("QB:4")
        customer_id: "27cc67093475061e3d95369d" #@customerLookup("QB:284")
        transaction_date: "2013-05-21" # from TxnDate above
        amount_cents: 400000
        source: "QB:Payment"
        is_credit: true
        period_id: "17cc67093475061e3d95369d" #@periodLookup("2013-05-21")
      ,
        company_id: @companyId
        qbd_id: "NG:3410926-debit"
        account_id: "18cc6709347adfae3d95369d" #@accountLookup("QB:2")
        customer_id: "27cc67093475061e3d95369d" #@customerLookup("QB:284")
        transaction_date: "2013-05-21" # from TxnDate above
        amount_cents: 400000
        source: "QB:Payment"
        is_credit: false
        period_id: "17cc67093475061e3d95369d" #@periodLookup("2013-05-21")
      ,
        amount_cents: 160000
        account_id: "19cc6709347adfae3d95369d"
        company_id: @companyId
        qbd_id: "QB:213"
        customer_id: "27cc67093475061e3d95369d" #@customerLookup("QB:284")
        transaction_date: "2013-05-21" # from TxnDate above
        source: "QB:Payment"
        is_credit: false
        period_id: "17cc67093475061e3d95369d" #@periodLookup("2013-05-21")
      ,
        amount_cents: 240000
        account_id: "16cc6709347adfae3d95369d"
        company_id: @companyId
        qbd_id: "QB:212"
        customer_id: "27cc67093475061e3d95369d" #@customerLookup("QB:284")
        transaction_date: "2013-05-21" # from TxnDate above
        source: "QB:Payment"
        is_credit: false
        period_id: "17cc67093475061e3d95369d" #@periodLookup("2013-05-21")
      ]

      assert.deepEqual @payment.transform(@qbdObj, {}, @loadData, {}), resultObjs

    it 'logs a warning if ARAccountRef is not populated', (done)->
      delete @qbdObj.ARAccountRef
      @payment.transform(@qbdObj, {}, @loadData, {}, (messages) ->
        assert.equal messages.length, 1
        assert.equal messages[0].type, "warning"
        done()
      )

    it 'logs a warning if the total amount does not equal the sum of line amounts', (done)->
      @qbdObj.TotalAmt = 32412
      @payment.transform(@qbdObj, {}, @loadData, {}, (messages) ->
        assert.equal messages.length, 1
        assert.equal messages[0].type, "warning"
        done()
      )
