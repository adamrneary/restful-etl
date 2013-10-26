describe "xero ActiveCell", ->
  describe "Item object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

      @xeroObj =
        ItemID: "9a59ea90-942e-484d-9b71-d00ab607e03b"
        Code: "Merino-2011-LG"
        Description: "2011 Merino Sweater - LARGE"
        PurchaseDetails:
          UnitPrice: "149.00"
          AccountCode: "300"
        SalesDetails:
          UnitPrice: "299.00"
          AccountCode: "200"

    it "can transform a xeroObj in order to create a new Activecell obj", ->
