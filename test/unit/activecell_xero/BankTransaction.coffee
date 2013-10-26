describe "xero ActiveCell", ->
  describe "BankTransaction object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

      @xeroObj =
        Contact:
          ContactID: "c09661a2-a954-4e34-98df-f8b6d1dc9b19"
          ContactStatus: "ACTIVE"
          Name: "BNZ"
          Addresses:
            Address: [
                AddressType: "POBOX"
              ,
                AddressType: "STREET"
            ]
          Phones:
            Phone: [
                PhoneType: "DEFAULT"
              ,
                PhoneType: "MOBILE"
              ,
                PhoneType: "DDI"
              ,
                PhoneType: "FAX"
            ]
          UpdatedDateUTC: "2010-09-17T19:26:39.157"
        Date: "2010-07-30T00:00:00"
        LineAmountTypes: "Inclusive"
        LineItems:
          LineItem:
            Description: "Monthly account fee"
            UnitAmount: "15"
            TaxType: "NONE"
            TaxAmount: "0.00"
            LineAmount: "15.00"
            AccountCode: "404"
            Quantity: "1.0000"
        SubTotal: "15.00"
        TotalTax: "0.00"
        Total: "15.00"
        UpdatedDateUTC: "2008-02-20T12:19:56.657"
        FullyPaidOnDate: "2010-07-30T00:00:00"
        BankTransactionID: "d20b6c54-7f5d-4ce6-ab83-55f609719126"
        BankAccount:
          AccountID: "297c2dc5-cc47-4afd-8ec8-74990b8761e9"
          Code: "BANK"
        Type: "SPEND"
        IsReconciled: "true"

    it "can transform a xeroObj in order to create a new Activecell obj", ->
