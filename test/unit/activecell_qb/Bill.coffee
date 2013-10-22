Bill = require("../../../lib/load/providers/activecell_objects/qb/bill").class
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
            Id: "NG:3629083"
            Description: "Testing Exp"
            Amount: 500
            DetailType: "AccountBasedExpenseLineDetail"
            AccountBasedExpenseLineDetail:
              CustomerRef:
                value: "QB:260"
                name: "Apple"
              ClassRef:
                value: "QB:1"
                name: "New Construction"
              AccountRef:
                value: "QB:32"
                name: "Fuel"
              BillableStatus: "Billable"
            },
            CustomField:[]
          ,
            Id: "QB:123"
            Amount: 456
            DetailType: "ItemBasedExpenseLineDetail"
            ItemBasedExpenseLineDetail:
              ItemRef: {value: 'QB:345'}
          ]
          TxnTaxDetail:
            TaxLine: []
          VendorRef:
            value: "QB:164",
            name: "Bank of Anycity"
          APAccountRef:
            value: "QB:12",
            name: "Accounts Payable"
          TotalAmt:1990.19
      @bill = new Bill(@companyId)

      # NOTE TO IGOR: Since we are unit testing the different types of lines,
      # maybe we should just stub the lines for these documents to save time.

    resultObjs = [
      company_id: @companyId
      source: 'QB:Bill'
      qbd_id: 'NG:3424987'
      is_credit: true
      account_id: @accountLookup("QB:32")
      vendor_id: @vendorLookup("QB:164")
      transaction_date: "2013-02-05" # from TxnDate above
      period_id: @periodLookup("2013-02-05")
      amount_cents: 199019
    ,
      company_id: @companyId
      source: 'QB:Bill'
      qbd_id: 'NG:3629083'
      is_credit: false
      account_id: @accountLookup("QB:12")
      vendor_id: @vendorLookup("QB:164")
      transaction_date: "2013-02-05" # from TxnDate above
      period_id: @periodLookup("2013-02-05")
      amount_cents: 50000
    ,
      company_id: @companyId
      source: 'QB:Bill'
      qbd_id: 'NG:3629083'
      is_credit: false
      account_id: @accountLookup(@itemLookup('QB:345')['ExpenseAccountRef'])
      product_id:  @productLookup('QB:345')
      vendor_id: @vendorLookup("QB:164")
      transaction_date: "2013-02-05" # from TxnDate above
      period_id: @periodLookup("2013-02-05")
      amount_cents: 45600
    ]