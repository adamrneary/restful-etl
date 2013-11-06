lineTranform = require("../../../../lib/load/providers/activecell/utils/utils").lineTranform
assert  = require("chai").assert

describe "qbd ActiveCell", ->
  describe "JournalEntryLineDetail", ->

    beforeEach () ->
      @qbdObj =
        Id: "QB:123"
        Amount: 500
        DetailType: "JournalEntryLineDetail"
        JournalEntryLineDetail:
          PostingType: "Credit"
          Entity:
            Type: "Vendor"
            EntityRef: {value: "QB:234"}
          AccountRef: {value: "QB:345"}

    it "can find an account based on the item", ->
      resultObj =
        Id: "QB:123"
        amount_cents: 500
        PostingType: "Credit"
        account_id: "QB:345"#@accountLookup(@itemLookup('QB:345')['ExpenseAccountRef'])
        vendor_id: "QB:234"#@vendorLookup('QB:234') # See entity type ref. This could be customer or vendor.

      assert.deepEqual lineTranform(@qbdObj), resultObj
