lineTranform = require("../../../../lib/load/providers/activecell_objects/qb/utils/utils").lineTranform
assert  = require("chai").assert

describe "qbd ActiveCell", ->
  describe "AccountBasedExpenseLineDetail", ->
    beforeEach () ->
      @qbdObj =
        Id: "QB:123"
        Amount: 500
        DetailType: "AccountBasedExpenseLineDetail"
        AccountBasedExpenseLineDetail:
          AccountRef: {value: 'QB:345'}

    it "can find an account based on the account ref", ->
      resultObj =
        Id: "QB:123"
        Amount: 500
        AccountId: "QB:345" #@accountLookup('QB:345')

      assert.deepEqual lineTranform(@qbdObj), resultObj
