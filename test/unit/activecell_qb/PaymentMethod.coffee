PaymentMethod = require("../../../lib/load/providers/activecell_objects/qb/payment_method").class
assert  = require("chai").assert

describe "qb ActiveCell", ->
  describe "paymentMethod object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

      @qbdObj =
        Name: "PM-CreateAll-1373580945815"
        Active: true
        Type: "CREDIT_CARD"
        domain: "QBO"
        sparse: false
        Id: "14"
        SyncToken: "0"
        MetaData:
          CreateTime: "2013-07-11T15:12:41-07:00"
          LastUpdatedTime: "2013-07-11T15:12:41-07:00"

      @paymentMethod = new PaymentMethod(@companyId)