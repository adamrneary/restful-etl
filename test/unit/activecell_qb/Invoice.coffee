Invoice = require("../../../lib/load/providers/activecell_objects/qb/Invoice").class
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
          Line:[
            Id: "QB:123"
            Amount: 1900
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
          TotalAmt: 3500
          TemplateRef:
            value: "QB:14"
            name: "Rock Castle Invoice"
          PrintStatus: "NotSet"
          EmailStatus: "NotSet"
          ARAccountRef:
            value: "QB:4"
            name: "Accounts Receivable"
          Balance: 3500
          FinanceCharge: false

      @loadData =
        accounts:
          [
            id: "17cc67093475061e3d95369d",
            qbd_id: "QB:4"
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
            qbd_id: "QB:286"
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
            first_day: "2010-03-01"
          ,
            id: "37cc67093475061e3d95369d",
            first_day: "2010-04-01"

            id: "17cc67093475061e3d95369d",
            first_day: "2010-05-01"
          ,
            id: "27cc67093475061e3d95369d",
            first_day: "2010-06-01"
          ]

      @invoice = new Invoice(@companyId)

    it "can transform a qbdObj in order to create a new Activecell obj", ->
      resultObjs = [
        company_id: @companyId
        qbd_id: "QB:64531"
        account_id: "17cc67093475061e3d95369d" #@accountLookup("QB:4")
        customer_id: "27cc67093475061e3d95369d" #@customerLookup("QB:286")
        transaction_date: "2010-06-16" # from TxnDate above
        amount_cents: 350000
        source: "QB:Invoice"
        is_credit: true
        period_id: "27cc67093475061e3d95369d" #@periodLookup("2010-06-16")
      ,
        amount_cents: 190000
        product_id: "37cc67093475061e3d95369d"
        account_id: "18cc6709347adfae3d95369d"
        company_id: @companyId
        qbd_id: "QB:123"
        customer_id: "27cc67093475061e3d95369d" #@customerLookup("QB:286")
        transaction_date: "2010-06-16" # from TxnDate above
        source: "QB:Invoice"
        is_credit: false
        period_id: "27cc67093475061e3d95369d" #@periodLookup("2010-06-16")
      ,
        amount_cents: 160000
        account_id: "19cc6709347adfae3d95369d"
        company_id: @companyId
        qbd_id: "QB:213"
        customer_id: "27cc67093475061e3d95369d" #@customerLookup("QB:286")
        transaction_date: "2010-06-16" # from TxnDate above
        source: "QB:Invoice"
        is_credit: false
        period_id: "27cc67093475061e3d95369d" #@periodLookup("2010-06-16")
      ]

      assert.deepEqual @invoice.transform(@qbdObj, {}, @loadData, {}), resultObjs

    it 'logs a warning if there are no lines', (done)->
      delete @qbdObj.Line
      @qbdObj.TotalAmt = 0
      @invoice.transform(@qbdObj, {}, @loadData, {}, (messages) ->
        assert.equal messages.length, 1
        assert.equal messages[0].type, "warning"
        done()
      )

    it 'logs a warning if CustomerRef is not populated', (done)->
      delete @qbdObj.CustomerRef
      @invoice.transform(@qbdObj, {}, @loadData, {}, (messages) ->
        assert.equal messages.length, 1
        assert.equal messages[0].type, "warning"
        done()
      )

    it 'logs a warning if the total amount does not equal the sum of line amounts', (done)->
      @qbdObj.TotalAmt = 32412
      @invoice.transform(@qbdObj, {}, @loadData, {}, (messages) ->
        assert.equal messages.length, 1
        assert.equal messages[0].type, "warning"
        done()
      )

