describe "xero ActiveCell", ->
  describe "ExpenseClaim object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

      @xeroObj =
        ExpenseClaimID: "e59a2c7f-1306-4078-a0f3-73537afcbba9"
        Status: "AUTHORISED"
        CreatedDateUTC: "2011-09-23T03:06:58.61"
        UpdatedDateUTC: "2011-09-23T03:16:56.67"
        User:
          UserID: "7cf47fe2-c3dd-4c6b-9895-7ba767ba529c"
          FirstName: "Joe"
          LastName: "Bloggs"
        Receipts: {
        Receipt: [
            ReceiptID: "0d9cfee4-a3df-4a36-bc45-8388ae5bc3b7"
            Status: "AUTHORISED"
            User:
              UserID: "7cf47fe2-c3dd-4c6b-9895-7ba767ba529c"
              FirstName: "Joe"
              LastName: "Bloggs"
            Contact:
              ContactID: "7f71b205-4ad9-4779-8479-60f46e91fa5c"
              Name: "Mojo Coffee"
            Date: "2011-09-23T00:00:00"
            UpdatedDateUTC: "2011-09-23T03:03:42.26"
            LineAmountTypes: "Inclusive"
            LineItems:
              LineItem:
                Description: "Lunch"
                UnitAmount: "12.80"
                TaxType: "INPUT2"
                TaxAmount: "1.67"
                LineAmount: "12.80"
                Quantity: "1.0000"
            SubTotal: "11.13"
            TotalTax: "1.67"
            Total: "12.80"
            HasAttachments: "false"
          ,
            ReceiptID: "443518d1-4f00-4ae3-9668-ce28c66a64ac"
            Status: "AUTHORISED"
            User:
              UserID: "7cf47fe2-c3dd-4c6b-9895-7ba767ba529c"
              FirstName: "Joe"
              LastName: "Bloggs"
            Contact:
              ContactID: "7f71b205-4ad9-4779-8479-60f46e91fa5c"
              Name: "Mojo Coffee"
            Date: "2010-07-15T00:00:00"
            UpdatedDateUTC: "2011-09-23T02:54:42.26"
            LineAmountTypes: "Inclusive"
            LineItems:
              LineItem:
                Description: "Coffee with client to discuss support contract"
                UnitAmount: "3.80"
                TaxType: "INPUT2"
                TaxAmount: "0.50"
                LineAmount: "3.80"
                Quantity: "1.0000"
            SubTotal: "3.30"
            TotalTax: "0.50"
            Total: "3.80"
            HasAttachments: "false"
        ]
        Total: "16.60"

    it "can transform a xeroObj in order to create a new Activecell obj", ->
