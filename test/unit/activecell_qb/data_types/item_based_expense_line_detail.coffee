lineTranform = require("../../../../lib/load/providers/activecell_objects/qb/utils/utils").lineTranform
assert  = require("chai").assert

describe "qbd ActiveCell", ->
  describe "ItemBasedExpenseLineDetail", ->

    it "can find an account based on the item", ->
      extractData =
        Item:[
          Name: "Freight Reimbursement"
          Id: "QB:345"
          ExpenseAccountRef:
            value: "QB:123"
        ]

      qbdObj =
        Id: "QB:123"
        Amount: 500
        DetailType: "ItemBasedExpenseLineDetail"
        ItemBasedExpenseLineDetail:
          ItemRef: {value: 'QB:345'}

      resultObj =
        Id: "QB:123"
        amount_cents: 50000
        account_id: "QB:123"#@accountLookup(@itemLookup('QB:345')['ExpenseAccountRef'])
        product_id: "QB:345"

      assert.deepEqual lineTranform(qbdObj, extractData), resultObj

    it "can find an account based on the item account ref", ->
      qbdObj =
        Id: "QB:123"
        Amount: 500
        DetailType: "ItemBasedExpenseLineDetail"
        ItemBasedExpenseLineDetail:
          ItemRef: {value: 'QB:345'}
          ItemAccountRef: {value: 'QB:678'}

      resultObj =
        Id: "QB:123"
        amount_cents: 50000
        account_id: "QB:678"
        product_id: "QB:345"

      assert.deepEqual lineTranform(qbdObj), resultObj
