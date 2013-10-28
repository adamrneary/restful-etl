Default = require("../../../lib/load/providers/activecell/qb/default").Default
assert  = require("chai").assert

describe "qbd ActiveCell", ->
  describe "default object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

      @qbdObj =
        BillAddr: {Line1: "American Express Settlement"}
        Job: false
        Balance: 0
        OpenBalanceDate: "2013-04-01"
        JobInfo: {Status:"None"}
        status: "Synchronized"
        Id: "QB:399"
        SyncToken: 1
        MetaData: {CreateTime:"2013-05-22T19:29:24Z", LastUpdatedTime: "2013-05-22T19:29:53Z"}
        Organization: false
        DisplayName: "American Express Settlement"
        Active: true
        DefaultTaxCodeRef: {value: "QB:1", name:"Tax"}
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

      @default = new Default(@companyId)

    it "can transform a qbdObj in order to create a new Activecell obj", ->
      resultObj =
        company_id: @companyId
        qbd_id: "QB:399"
        name: "American Express Settlement"

      assert.deepEqual @default.transform(@qbdObj), resultObj