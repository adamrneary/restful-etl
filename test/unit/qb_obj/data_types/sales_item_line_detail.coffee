lineTranform = require("../../../../lib/load/providers/activecell/utils/utils").lineTranform
assert  = require("chai").assert

describe "qbd ActiveCell", ->
  describe "SalesItemLineDetail", ->

    it "can find an account based on the item", ->
      extractData =
        Item:[
          Name: "Freight Reimbursement"
          Id: "QB:345"
          IncomeAccountRef:
            value: "QB:678"
        ]

      qbdObj =
        Id: "QB:123"
        Amount: 500
        DetailType: "SalesItemLineDetail"
        SalesItemLineDetail:
          ItemRef: {value: "QB:345"}

      resultObj =
        Id: "QB:123"
        amount_cents: 50000
        account_id: "QB:678" #@accountLookup(@itemLookup('QB:345')['IncomeAccountRef'])
        product_id: "QB:345" #@productLookup('QB:345')

      assert.deepEqual lineTranform(qbdObj, extractData), resultObj

    it "can find an account based on the item account ref", ->
      qbdObj =
        Id: "QB:123"
        Amount: 500
        DetailType: "SalesItemLineDetail"
        SalesItemLineDetail:
          ItemRef: {value: "QB:345"}
          ItemAccountRef: {value: "QB:678"}

      resultObj =
        Id: "QB:123"
        amount_cents: 50000
        account_id: "QB:678" #@accountLookup('QB:678')
        product_id: "QB:345" #@productLookup('QB:345')

      assert.deepEqual lineTranform(qbdObj), resultObj
