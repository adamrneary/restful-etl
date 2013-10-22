describe "qbd ActiveCell", ->
  describe "ItemBasedExpenseLineDetail", ->

    it "can find an account based on the item", ->
      @qbdObj =
        Id: "QB:123"
        Amount: 500
        DetailType: "ItemBasedExpenseLineDetail"
        ItemBasedExpenseLineDetail:
          ItemRef: {value: 'QB:345'}

      resultObj:
        Id: "QB:123"
        Amount: 500
        AccountId: @accountLookup(@itemLookup('QB:345')['ExpenseAccountRef'])
        ProductId: @productLookup('QB:345')

    it "can find an account based on the item account ref", ->
      @qbdObj =
        Id: "QB:123"
        Amount: 500
        DetailType: "ItemBasedExpenseLineDetail"
        ItemBasedExpenseLineDetail:
          ItemRef: {value: 'QB:345'}
          ItemAccountRef: {value: 'QB:678'}

      resultObj:
        Id: "QB:123"
        Amount: 500
        AccountId: @accountLookup('QB:678')
        ProductId: @productLookup('QB:345')