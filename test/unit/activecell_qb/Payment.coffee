Item = require("../../../lib/load/providers/activecell_objects/qb/item").class
assert  = require("chai").assert

describe "qb ActiveCell", ->
  describe "item object", ->
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
        TotalAmt: 40
        status: "Synchronized"
        Id: "NG:3410926"
        SyncToken: "6"
        MetaData:
          CreateTime: "2013-05-21T11:38:46Z"
          LastUpdatedTime: "2013-05-21T11:40:35Z"
        TxnDate: "2013-05-21"
        PrivateNote: "Testing with Cash and all fields mod"
        Line: [ ]

      @item = new Item(@companyId)