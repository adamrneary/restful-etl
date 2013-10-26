describe "xero ActiveCell", ->
  describe "Invoice object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

      @xeroObj =
        Type: "ACCREC"
        Contact:
          ContactID: "025867f1-d741-4d6b-b1af-9ac774b59ba7"
          ContactStatus: "ACTIVE"
          Name: "City Agency"
          Addresses:
            Address: [
                AddressType: "STREET"
              ,
                AddressType: "POBOX"
                AddressLine1: "L4, CA House"
                AddressLine2: "14 Boulevard Quay"
                City: "Wellington"
                PostalCode: "6012"
            ]
          Phones:
            Phone: [
                PhoneType: "DEFAULT"
              ,
                PhoneType: "DDI"
              ,
                PhoneType: "MOBILE"
              ,
                PhoneType: "FAX"
            ]
          UpdatedDateUTC: "2009-08-15T00:18:43.473"
          IsSupplier: "false"
          IsCustomer: "true"
        Date: "2009-05-27T00:00:00"
        DueDate: "2009-06-06T00:00:00"
        Status: "AUTHORISED"
        LineAmountTypes: "Exclusive"
        LineItems:
          LineItem:
            Description: "Onsite project management "
            Quantity: "1.0000"
            UnitAmount: "1800.00"
            TaxType: "OUTPUT"
            TaxAmount: "225.00"
            LineAmount: "1800.00"
            AccountCode: "200"
            Tracking:
              TrackingCategory:
                TrackingCategoryID: "e2f2f732-e92a-4f3a9c4d-ee4da0182a13"
                Name: "Activity/Workstream"
                Option: "Onsite consultancy"
        SubTotal: "1800.00"
        TotalTax: "225.00"
        Total: "2025.00"
        UpdatedDateUTC: "2009-08-15T00:18:43.457"
        CurrencyCode: "NZD"
        InvoiceID: "243216c5-369e-4056-ac67-05388f86dc81"
        InvoiceNumber: "OIT00546"
        Payments:
          Payment:
            Date: "2009-09-01T00:00:00"
            Amount: "1000.00"
            PaymentID: "0d666415-cf77-43fa-80c7-56775591d426"
        AmountDue: "1025.00"
        AmountPaid: "1000.00"
        AmountCredited: "0.00"

    it "can transform a xeroObj in order to create a new Activecell obj", ->
