PaymentMethod = require("../../../lib/load/providers/activecell_objects/qb/payment_method").class
assert  = require("chai").assert

describe "qb ActiveCell", ->
  describe "paymentMethod object", ->
    # DO NOT IMPORT FOR NOW