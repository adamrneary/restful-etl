describe "xero ActiveCell", ->
  describe "Payment object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

      @xeroObj =
        Invoice: { InvoiceNumber: "OIT00545" }
        Account: { Code: "001" }
        Date: "2009-09-08T00:00:00"
        Amount: "32.06"

    it "can transform a xeroObj in order to create a new Activecell obj", ->
