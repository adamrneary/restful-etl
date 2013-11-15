lineTranform = require("../../../../lib/load/providers/activecell/utils/utils").lineTranform
assert  = require("chai").assert

describe "qbd ActiveCell", ->
  describe "DepositLineDetail", ->
    beforeEach () ->
      @qbdObj =
        Id: "QB:123"
        Amount: 500
        DetailType: "DepositLineDetail"
        DepositLineDetail:
          AccountRef: {value: 'QB:345'}

    it "can find an account based on the account ref", ->
      resultObj =
        Id: "QB:123"
        amount_cents: 500
        account_id: "QB:345" #@accountLookup('QB:345')

      assert.deepEqual lineTranform(@qbdObj), resultObj
