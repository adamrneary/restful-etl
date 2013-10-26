describe "xero ActiveCell", ->
  describe "CreditNote object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

      @xeroObj =
        Contact:
          ContactID: "c6c7b870-bb4d-489a-921e-2f0ee4192ff9"
          Name: "Test Apply Credit Note"
        Date: "2012-08-30T00:00:00"
        Status: "PAID"
        LineAmountTypes: "Inclusive"
        SubTotal: "86.96"
        TotalTax: "13.04"
        Total: "100.00"
        UpdatedDateUTC: "2012-08-29T23:43:01.097"
        CurrencyCode: "NZD"
        FullyPaidOnDate: "2012-08-30T00:00:00"
        Type: "ACCRECCREDIT"
        CreditNoteID: "aea95d78-ea48-456b-9b08-6bc012600072"
        CreditNoteNumber: "CN-0002"
        CurrencyRate: "1.000000"
        RemainingCredit: "0.00"
        Allocations:
          Allocation:
            AppliedAmount: "100.00"
            Date: "2012-08-30T00:00:00"
            Invoice:
              InvoiceID: "87cfa39f-136c-4df9-a70d-bb80d8ddb975"
              InvoiceNumber: "INV-0001"

    it "can transform a xeroObj in order to create a new Activecell obj", ->
