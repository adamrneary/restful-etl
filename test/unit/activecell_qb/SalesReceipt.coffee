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

      @loadData =
        accounts:
          [
            id: "17cc67093475061e3d95369d",
            qbd_id: "4"
          ,
            id: "18cc6709347adfae3d95369d",
            qbd_id: "QB:678"
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
            qbd_id: "239393"
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

      @salesReceipt = new SalesReceipt(@companyId)

    it "can transform a qbdObj in order to create a new Activecell obj", ->
      resultObjs = [
        company_id: @companyId
        qbd_id: "97"
        account_id: "17cc67093475061e3d95369d" #@accountLookup("4")
        customer_id: "27cc67093475061e3d95369d" #@customerLookup("239393")
        transaction_date: "2013-03-13" # from TxnDate above
        amount_cents: 500
        source: "QB:SalesReceipt"
        is_credit: false
        period_id: "37cc67093475061e3d95369d" #@periodLookup("2013-03-13")
      ,
        amount_cents: 50000
        product_id: "37cc67093475061e3d95369d"
        account_id: "18cc6709347adfae3d95369d"
        company_id: @companyId
        qbd_id: "QB:123"
        customer_id: "27cc67093475061e3d95369d" #@customerLookup("239393")
        transaction_date: "2013-03-13" # from TxnDate above
        source: "QB:SalesReceipt"
        is_credit: true
        period_id: "37cc67093475061e3d95369d" #@periodLookup("2013-03-13")
      ,
        amount_cents: 160000
        account_id: "19cc6709347adfae3d95369d"
        company_id: @companyId
        qbd_id: "QB:213"
        customer_id: "27cc67093475061e3d95369d" #@customerLookup("239393")
        transaction_date: "2013-03-13" # from TxnDate above
        source: "QB:SalesReceipt"
        is_credit: true
        period_id: "37cc67093475061e3d95369d" #@periodLookup("2013-03-13")
      ]

      assert.deepEqual @salesReceipt.transform(@qbdObj, {}, @loadData, {}), resultObjs
