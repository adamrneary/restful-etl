describe "xero ActiveCell", ->
  describe "TrackingCategory object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

      @xeroObj =
        Name: "Region"
        Status: "ACTIVE"
        TrackingCategoryID: "093af706-c2aa-4d97-a4ce-2d205a017eac"
        Options:
          Option: [
              TrackingOptionID: "ae777a87-5ef3-4fa0-a4f0-d10e1f13073a"
              Name: "Eastside"
            ,
              TrackingOptionID: "3f05cdf9-246b-46a2-bf6f-441da1b09b89"
              Name: "North"
            ,
              TrackingOptionID: "9f93bb09-3c8c-4d43-a6fe-862772d77bd9"
              Name: "South"
            ,
              TrackingOptionID: "2ba6a2af-11cb-452d-9867-dce88add6856"
              Name: "West Coast"
          ]

    it "can transform a xeroObj in order to create a new Activecell obj", ->
