describe "qbd ActiveCell", ->
  describe "SalesItemLineDetail", ->

    it "can find an account based on the item", ->
      @qbdObj =
        Id: "QB:123"
        Amount: 500
        DetailType: "SalesItemLineDetail"
        SalesItemLineDetail:
          ItemRef: {value: 'QB:345'}

      resultObj:
        Id: "QB:123"
        Amount: 500
        AccountId: @accountLookup(@itemLookup('QB:345')['IncomeAccountRef'])
        ProductId: @productLookup('QB:345')

    it "can find an account based on the item account ref", ->
      @qbdObj =
        Id: "QB:123"
        Amount: 500
        DetailType: "SalesItemLineDetail"
        SalesItemLineDetail:
          ItemRef: {value: 'QB:345'}
          ItemAccountRef: {value: 'QB:678'}

      resultObj:
        Id: "QB:123"
        Amount: 500
        AccountId: @accountLookup('QB:678')
        ProductId: @productLookup('QB:345')