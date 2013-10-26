describe "xero ActiveCell", ->
  describe "BrandingTheme object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

      @xeroObj =
        BrandingThemeID: "a94a78db-5cc6-4e26-a52b-045237e56e6e"
        Name: "Standard"
        SortOrder: "0"
        CreatedDateUTC: "2010-06-29T18:16:36.27"

    it "can transform a xeroObj in order to create a new Activecell obj", ->
