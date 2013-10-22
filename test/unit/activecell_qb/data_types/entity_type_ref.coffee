describe "qbd ActiveCell", ->
  describe "EntityTypeRef", ->

    it "can identify a customer", ->
      @qbdObj =
        Entity:
          Type: 'Customer'
          EntityRef: {value: 'QB:234'}

      resultObj:
        CustomerId: @customerLookup('QB:234')

    it "can identify a vendor", ->
      @qbdObj =
        Entity:
          Type: 'Vendor'
          EntityRef: {value: 'QB:234'}

      resultObj:
        VendorId: @vendorLookup('QB:234')