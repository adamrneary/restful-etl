describe "xero ActiveCell", ->
  describe "Employee object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

      @xeroObj =
        EmployeeID: "514ad9aa-8e4b-4a0a-859a-9f72658eeadc"
        Status: "ACTIVE"
        FirstName: "Homer"
        LastName: "Simpson"
        ExternalLink:
          Url: "http://twitter.com/#!/search/Homer+Simpson"
          Description: "Go to Twitter"

    it "can transform a xeroObj in order to create a new Activecell obj", ->
