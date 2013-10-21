TaxCode = require("../../../lib/load/providers/activecell_objects/qb/tax_code").class
assert  = require("chai").assert

describe "qb ActiveCell", ->
  describe "taxCode object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

      @qbdObj =
        Name:"1% Tax"
        Description:"1% Tax"
        Active:true
        Taxable:true
        TaxGroup:true
        SalesTaxRateList:
          TaxRateDetail:[
            TaxRateRef:
              value: "80",
              name: "1% Tax (Sales)"
            TaxTypeApplicable:"TaxOnAmount"
            TaxOrder:0
          ]
        PurchaseTaxRateList:
          TaxRateDetail:[]
        domain: "QBO"
        sparse: false
        Id: "33"
        SyncToken: "0"
        MetaData:
          CreateTime: "2012-10-15T16:40:00-07:00"
          LastUpdatedTime: "2012-10-15T16:40:00-07:00"
      @taxCode = new TaxCode(@companyId)