transromRefs = require("../../../../lib/load/providers/activecell/utils/utils").transromRefs
assert  = require("chai").assert

describe "qbd ActiveCell", ->
  describe "EntityTypeRef", ->

    it "can identify a customer", ->
      qbdObj =
        CustomerRef:
          value: "QB:234"

      resultObj =
        customer_id: "QB:234"

      assert.deepEqual transromRefs(qbdObj), resultObj

    it "can identify a vendor", ->
      qbdObj =
        CustomerRef:
          value: "QB:234"
          type: "Vendor"

      resultObj =
        vendor_id: "QB:234"

      assert.deepEqual transromRefs(qbdObj), resultObj
