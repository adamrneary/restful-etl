lineTranform = require("../../../../lib/load/providers/activecell/utils/utils").lineTranform
assert  = require("chai").assert

describe "qbd ActiveCell", ->
  describe "PaymentLineDetail", ->

    it "can find an account based on the item", ->
      extractData =
        Item:[
          Name: "Freight Reimbursement"
          Id: "QB:345"
          DepositToAccountRef:
            value: "QB:678"
        ]

      qbdObj =
        Id: "QB:123"
        Amount: 500
        DetailType: "PaymentLineDetail"
        PaymentLineDetail:
          ItemRef: {value: "QB:345"}

      resultObj =
        Id: "QB:123"
        amount_cents: 500
        product_id: "QB:345"
        account_id: "QB:678"

      assert.deepEqual lineTranform(qbdObj, extractData), resultObj

    it "can find an account based on the discount account ref", ->
      qbdObj =
        Id: "QB:123"
        Amount: 500
        DetailType: "PaymentLineDetail"
        PaymentLineDetail:
          Discount:
            DiscountAccountRef: {value: "QB:678"}

      resultObj =
        Id: "QB:123"
        amount_cents: 500
        account_id: "QB:678"

      assert.deepEqual lineTranform(qbdObj), resultObj