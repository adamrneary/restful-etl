describe "xero ActiveCell", ->
  describe "User object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

      @xeroObj =
        UserID: "7cf47fe2-c3dd-4c6b-9895-7ba767ba529c"
        FirstName: "John"
        LastName: "Smith"
        UpdatedDateUTC: "2010-03-03T22:23:26.94"
        IsSubscriber: "true"
        OrganisationRole: "ADMIN"

    it "can transform a xeroObj in order to create a new Activecell obj", ->
