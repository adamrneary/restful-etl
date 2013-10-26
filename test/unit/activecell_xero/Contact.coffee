describe "xero ActiveCell", ->
  describe "Contact object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

      @xeroObj =
        ContactID: "bd2270c3-8706-4c11-9cfb-000b551c3f51"
        ContactStatus: "ACTIVE"
        Name: "ABC Limited"
        FirstName: "Andrea"
        LastName: "Dutchess"
        EmailAddress: "a.dutchess@abclimited.com"
        SkypeUserName: "skype.dutchess@abclimited.com"
        BankAccountDetails: "skype.dutchess@abclimited.com"
        TaxNumber: "skype.dutchess@abclimited.com"
        AccountsReceivableTaxType: "INPUT2"
        AccountsPayableTaxType: "OUTPUT2"
        Addresses:
          Address: [
              AddressType: "POBOX"
              AddressLine1: "P O Box 123"
              City: "Wellington"
              PostalCode: "6011"
              AttentionTo: "Andrea"
            ,
              AddressType: "STREET"
          ]
        Phones:
          Phone: [
              PhoneType: "DEFAULT"
              PhoneNumber: "1111111"
              PhoneAreaCode: "04"
              PhoneCountryCode: "64"
            ,
              PhoneType: "FAX"
            ,
              PhoneType: "MOBILE"
            ,
              PhoneType: "DDI"
          ]
        UpdatedDateUTC: "2009-05-14T01:44:26.747"
        IsSupplier: "false"
        IsCustomer: "true"
        DefaultCurrency: "NZD"

    it "can transform a xeroObj in order to create a new Activecell obj", ->
