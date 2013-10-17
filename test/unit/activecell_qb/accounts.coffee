Accounts = require("../../../lib/load/providers/activecell_objects/qb/accounts").class
assert  = require("chai").assert

describe "qb ActiveCell", ->
  describe "accounts object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

      @qbdObj =
        Name: "Chase Operating"
        SubAccount: false
        Active: true
        Classification: "Asset"
        AccountType: "Bank"
        AcctNum: 10400
        CurrentBalance: 12823.22
        OnlineBankingEnabled: true
        status: "Synchronized"
        Id: "QB:147"
        SyncToken: 1
        MetaData: {CreateTime: "2013-05-22T19:46:46Z", LastUpdatedTime: "2013-09-20T20:29:09Z"}

      @accounts = new Accounts(@companyId)

#    it "can transform a qbdObj in order to create a new Activecell obj", ->
#
#
#    it "filters comparison to valid Activecell objects", ->
#
#    it "can compare objObjs with Activecell objects", ->
#
#    it "can update an existing object", ->
