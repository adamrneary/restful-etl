describe "xero ActiveCell", ->
  describe "Journal object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

      @xeroObj =
        JournalID: "0d926df3-459f-4264-a3a3-49ac065eb0ed"
        JournalDate: "2010-06-29T00:00:00"
        JournalNumber: "388"
        CreatedDateUTC: "2010-09-16T23:00:33.613"
        Reference: "Web"
        JournalLines:
          JournalLine: [
              JournalLineID: "8f99fb82-46b6-496d-864e-f8e0bc3e2922"
              AccountID: "5040915e-8ce7-4177-8d08-fde416232f18"
              AccountCode: "1100"
              AccountType: "REVENUE"
              AccountName: "Sales"
              NetAmount: "-300.00"
              GrossAmount: "-337.50"
              TaxAmount: "-37.50"
              TaxType: "OUTPUT"
              TaxName: "12.5% GST on Income"
              TrackingCategories:
                TrackingCategory:
                  Name: "Region"
                  Option: "Central"
                  TrackingCategoryID: "e2f2f732-e92a-4f3a-9c4d-ee4da0182a13"
            ,
              JournalLineID: "45db4370-3eed-4394-93bb-e83f1d54691d"
              AccountID: "9fef6d9d-4bce-4bcc-8679-f50e5ebd12e5"
              AccountCode: "820"
              AccountType: "CURRLIAB"
              AccountName: "GST"
              NetAmount: "-37.50"
              GrossAmount: "-37.50"
              TaxAmount: "0.00"
              TrackingCategories:
                TrackingCategory:
                  Name: "Region"
                  Option: "Central"
                  TrackingCategoryID: "e2f2f732-e92a-4f3a-9c4d-ee4da0182a13"
            ,
              JournalLineID: "0696bb65-d23c-4bc7-b693-71c30b448dc9"
              AccountID: "240c0528-24ef-42f6-82ed-dab806c79440"
              AccountCode: "610"
              AccountType: "CURRENT"
              AccountName: "Accounts Receivable"
              NetAmount: "337.50"
              GrossAmount: "337.50"
              TaxAmount: "0.00"
              TrackingCategories:
                TrackingCategory:
                  Name: "Region"
                  Option: "Central"
                  TrackingCategoryID: "e2f2f732-e92a-4f3a-9c4d-ee4da0182a13"
          ]

    it "can transform a xeroObj in order to create a new Activecell obj", ->
