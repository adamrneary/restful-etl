Vendors = require("../../../lib/load/providers/activecell_objects/qb/vendors").class
assert  = require("chai").assert

describe "qbd ActiveCell", ->
  describe "vendors object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

      @qbdObj =
        BillAddr: {Line1: "Early Pay Discount"}
        PrefillAccountRef: {value: "QB:20", name: "Bank Service Charges"}
        Balance: 0
        OpenBalanceDate: "2013-04-21"
        Vendor1099: false
        status: "Synchronized"
        Id: "QB:401"
        SyncToken: 1
        MetaData: {CreateTime: "2013-05-22T19:43:16Z", LastUpdatedTime:"2013-05-22T20:29:16Z"}
        Organization: false
        DisplayName: "Early Pay Discount"
        Active: true

      @vendors = new Vendors(@companyId)

#    it "can transform a qbdObj in order to create a new Activecell obj", ->
#
#    it "filters comparison to valid Activecell objects", ->
#
#    it "can compare objObjs with Activecell objects", ->
#
#    it "can update an existing object", ->
    