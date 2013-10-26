describe "xero ActiveCell", ->
  describe "ManualJournal object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

      @xeroObj =
        Date: "2011-01-31T00:00:00"
        Status: "DRAFT"
        LineAmountTypes: "NoTax"
        UpdatedDateUTC: "2011-02-07T20:26:28.757"
        ManualJournalID: "1e6b1916-6d82-4fa2-96f8-f17b33641538"
        Narration: "Accrued expenses - prepaid insurance adjustment for January 2011"
        JournalLines:
          JournalLine: [
              Description: "Accrued expenses - prepaid insurance adjustment for January 2011"
              TaxType: "NONE"
              LineAmount: "55.00"
              AccountCode: "433"
            ,
              Description: "Accrued expenses - prepaid insurance adjustment for January 2011"
              TaxType: "NONE"
              LineAmount: "-55.00"
              AccountCode: "620"
          ]

    it "can transform a xeroObj in order to create a new Activecell obj", ->
