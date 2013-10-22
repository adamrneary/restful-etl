describe "qbd ActiveCell", ->
  describe "AccountBasedExpenseLineDetail", ->

    it "can find an account based on the account ref", ->
      @qbdObj =
        Id: "QB:123"
        Amount: 500
        DetailType: "AccountBasedExpenseLineDetail"
        AccountBasedExpenseLineDetail:
          AccountRef: {value: 'QB:345'}

      resultObj:
        Id: "QB:123"
        Amount: 500
        AccountId: @accountLookup('QB:345')