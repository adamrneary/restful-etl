Bill = require("../../../lib/load/providers/activecell_objects/qb/Bill").class
assert  = require("chai").assert

describe "qb ActiveCell", ->
  describe "bill object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

      @qbdObj =
          DueDate:"2013-02-15"
          Balance:1990.19,
          status:"Pending"
          Id: "NG:3424987"
          SyncToken: "1"
          MetaData:
            CreateTime: "2013-06-03T11:52:25Z"
            LastUpdatedTime: "2013-06-03T11:52:25Z"
          CustomField:[ ]
          DocNumber: "TEST001"
          TxnDate: "2013-02-05"
          PrivateNote: "tESTING with ll types of Line itesms"
          TxnStatus: "Payable"
          Line:[
              Id: "QB:123"
              Amount: 390
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
            TaxLine: []
          VendorRef:
            value: "QB:164",
            name: "Bank of Anycity"
          APAccountRef:
            value: "QB:12",
            name: "Accounts Payable"
          TotalAmt:1990

      @loadData =
        accounts:
          [
            id: "17cc67093475061e3d95369d",
            qbd_id: "QB:12"
          ,
            id: "18cc6709347adfae3d95369d",
            qbd_id: "QB:678"
          ,
            id: "19cc6709347adfae3d95369d",
            qbd_id: "QB:345"
          ]
        vendors:
          [
            id: "27cc67093475061e3d95369d",
            qbd_id: "QB:164"
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

      @bill = new Bill(@companyId)

    it "can transform a qbdObj in order to create a new Activecell obj", ->
      resultObjs = [
        company_id: @companyId
        qbd_id: "NG:3424987"
        account_id: "17cc67093475061e3d95369d"#@accountLookup("QB:32")
        vendor_id: "27cc67093475061e3d95369d"#@vendorLookup("QB:164")
        transaction_date: "2013-02-05" # from TxnDate above
        amount_cents: 199000
        source: "QB:Bill"
        is_credit: true
        period_id: "2013-02-05"#@periodLookup("2013-02-05")
      ,
        amount_cents: 39000
        product_id: "37cc67093475061e3d95369d"
        account_id: "18cc6709347adfae3d95369d"
        company_id: @companyId
        qbd_id: "QB:123"
        vendor_id: "27cc67093475061e3d95369d"#@vendorLookup("QB:164")
        transaction_date: "2013-02-05" # from TxnDate above
        source: "QB:Bill"
        is_credit: false
        period_id: "2013-02-05"#@periodLookup("2013-02-05")
      ,
        amount_cents: 160000
        account_id: "19cc6709347adfae3d95369d"
        company_id: @companyId
        qbd_id: "QB:213"
        vendor_id: "27cc67093475061e3d95369d"#@vendorLookup("QB:164")
        transaction_date: "2013-02-05" # from TxnDate above
        source: "QB:Bill"
        is_credit: false
        period_id: "2013-02-05"#@periodLookup("2013-02-05")
      ]

      assert.deepEqual @bill.transform(@qbdObj, {}, @loadData, {}), resultObjs

    it "logs a warning if the total amount does not equal the sum of line amounts", (done)->
      @qbdObj.TotalAmt = 32412
      @bill.transform(@qbdObj, {}, {}, {}, (messages) ->
        assert.equal messages.length, 1
        assert.equal messages[0].type, "warning"
        done()
      )
