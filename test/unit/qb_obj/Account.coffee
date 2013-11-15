Account = require("../../../lib/load/providers/activecell/qb/Account").class
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
        AcctNum: "10400"
        CurrentBalance: 12823.22
        OnlineBankingEnabled: true
        status: "Synchronized"
        Id: "QB:147"
        SyncToken: 1
        MetaData: {CreateTime: "2013-05-22T19:46:46Z", LastUpdatedTime: "2013-09-20T20:29:09Z"}
        ParentRef: {value: "QB:37", name: "Capital Stock"}

      @account = new Account(@companyId)

    it "can transform a qbdObj in order to create a new Activecell obj", ->
      resultObj =
        company_id: @companyId
        qbd_id: "QB:147"
        name: "Chase Operating"
        type: "Asset"
        sub_type: "Bank"
        account_number: "10400"
        current_balance: 1282322
        parent_account_id: "QB:37"

      assert.deepEqual @account.transform(@qbdObj), [resultObj]