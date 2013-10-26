describe "xero ActiveCell", ->
  describe "Account object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

      @qbdObj =
        AccountID: "297c2dc5-cc47-4afd-8ec8-74990b8761e9"
        Name: "BNZ Cheque Account"
        Type: "BANK"
        TaxType: "NONE"
        EnablePaymentsToAccount: "false"
        BankAccountNumber: "3809087654321500"
        CurrencyCode: "NZD"

    it "can transform a xeroObj in order to create a new Activecell obj", ->
