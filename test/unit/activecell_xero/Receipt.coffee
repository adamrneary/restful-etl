describe "xero ActiveCell", ->
  describe "Receipt object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

      @xeroObj =
        ReceiptID: "e59a2c7f-1306-4078-a0f3-73537afcbba9"
        ReceiptNumber: "6"
        Status: "DRAFT"
        User:
          UserID: "c81045b2-5740-4aea-bf8a-3956941af387"
          FirstName: "John"
          LastName: "Smith"
        Contact:
          ContactID: "ee9619df-7419-446d-af3d-6becf72d9e64"
          ContactStatus: "ACTIVE"
          Name: "Faster Taxis"
          Addresses:
            Address: [
                AddressType: "POBOX"
              ,
                AddressType: "STREET"
            ]
          Phones:
            Phone: [
              PhoneType: "MOBILE"
              ,
              PhoneType: "FAX"
              ,
              PhoneType: "DDI"
              ,
              PhoneType: "DEFAULT"
            ]
          UpdatedDateUTC: "2011-10-02T19:41:43.817"
        Date: "2011-09-30T00:00:00"
        UpdatedDateUTC: "2011-10-02T20:09:09.067"
        LineAmountTypes: "Inclusive"
        LineItems:
          LineItem:
            Description: "Cab to Airport"
            UnitAmount: "18.62"
            TaxType: "INPUT2"
            TaxAmount: "2.43"
            LineAmount: "18.62"
            AccountCode: "420"
            Quantity: "1.0000"
        SubTotal: "16.19"
        TotalTax: "2.43"
        Total: "18.62"
        HasAttachments: "false"

    it "can transform a xeroObj in order to create a new Activecell obj", ->
