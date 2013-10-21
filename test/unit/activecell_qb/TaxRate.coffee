TaxRate = require("../../../lib/load/providers/activecell_objects/qb/tax_rate").class
assert  = require("chai").assert

describe "qb ActiveCell", ->
  describe "taxRate object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

      @qbdObj =
        Name: "TX1"
        Description: "Sales Tax for TX1"
        Active: true
        RateValue: 10
        AgencyRef:
          value: "QB:99"
          name: "City of East Bayshore"
        status: "Pending"
        Id: "NG:3109479"
        SyncToken: "1"
        MetaData:
          CreateTime: "2013-04-03T10:09:02Z"
          LastUpdatedTime: "2013-04-03T10:09:02Z"

      @taxRate = new TaxRate(@companyId)