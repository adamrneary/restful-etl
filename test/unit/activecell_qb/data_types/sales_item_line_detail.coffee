lineTranform = require("../../../../lib/load/providers/activecell_objects/qb/utils/utils").lineTranform
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
        Amount: 500
        AccountId: "QB:678" #@accountLookup(@itemLookup('QB:345')['IncomeAccountRef'])
        ProductId: "QB:345" #@productLookup('QB:345')

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
        Amount: 500
        AccountId: "QB:678" #@accountLookup('QB:678')
        ProductId: "QB:345" #@productLookup('QB:345')

      assert.deepEqual lineTranform(qbdObj), resultObj
