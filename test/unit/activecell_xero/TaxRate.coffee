describe "xero ActiveCell", ->
  describe "TaxRate object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

      @xeroObj =
        Name: "GST on Expenses"
        TaxType: "INPUT"
        CanApplyToAssets: "true"
        CanApplyToEquity: "true"
        CanApplyToExpenses: "true"
        CanApplyToLiabilities: "true"
        CanApplyToRevenue: "false"
        DisplayTaxRate: "10.0000"
        EffectiveRate: "10.0000"
        Status: "ACTIVE"

    it "can transform a xeroObj in order to create a new Activecell obj", ->
