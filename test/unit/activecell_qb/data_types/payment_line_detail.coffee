describe "qbd ActiveCell", ->
  describe "PaymentLineDetail", ->

    it "can find an account based on the item", ->
      @qbdObj =
        Id: "QB:123"
        Amount: 500
        DetailType: "PaymentLineDetail"
        PaymentLineDetail:
          ItemRef: {value: 'QB:345'}

      resultObj:
        Id: "QB:123"
        Amount: 500
        AccountId: @accountLookup(@itemLookup('QB:345')['DepositToAccountRef'])
        ProductId: @productLoopup('QB:345')

    it "can find an account based on the discount account ref", ->
      @qbdObj =
        Id: "QB:123"
        Amount: 500
        DetailType: "PaymentLineDetail"
        PaymentLineDetail:
          Discount:
            DiscountAccountRef: {value: 'QB:678'}

      resultObj:
        Id: "QB:123"
        Amount: 500
        AccountId: @accountLookup('QB:678')