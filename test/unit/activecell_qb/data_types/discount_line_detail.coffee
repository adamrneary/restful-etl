describe "qbd ActiveCell", ->
  describe "DiscountLineDetail", ->

    it "can find an account based on the discount account ref", ->
      @qbdObj =
        Id: "QB:123"
        Amount: 500
        DetailType: "DiscountLineDetail"
        DiscountLineDetail:
          Discount:
            DiscountAccountRef: {value: 'QB:678'}

      resultObj:
        Id: "QB:123"
        Amount: 500
        AccountId: @accountLookup('QB:678')