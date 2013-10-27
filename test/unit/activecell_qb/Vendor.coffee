Vendor = require("../../../lib/load/providers/activecell_objects/qb/Vendor").class
assert  = require("chai").assert

describe "qbd ActiveCell", ->
  describe "Vendor object", ->
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

      @vendor = new Vendor(@companyId)

    it "can transform a qbdObj in order to create a new Activecell obj", ->
     resultObj =
       company_id: @companyId
       qbd_id: "QB:401"
       name: "Early Pay Discount"

     assert.deepEqual @vendor.transform(@qbdObj), resultObj