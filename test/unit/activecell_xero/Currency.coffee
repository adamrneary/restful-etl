describe "xero ActiveCell", ->
  describe "Currency object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

      @xeroObj =
        Code: "NZD"
        Description: "New Zealand Dollar"

    it "can transform a xeroObj in order to create a new Activecell obj", ->
