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
        ParentRef: {value: "QB:37", name: "Capital Stock"}

      @accounts = new Accounts(@companyId)

   it "can transform a qbdObj in order to create a new Activecell obj", ->
     resultObj =
        company_id: @companyId
        qbd_id: "QB:147"
        name: "Chase Operating"
        type: "Asset"
        subtype: "Bank"
        account_number: "10400"
        current_balance: 1282322
        parent_qb_id: "QB:37"

    # Note: To achieve this, we need to create/update all qb accounts first.
    # Then, we look up company_id, qbd_id, parent_qb_id, and id from activecell
    # accounts.
    #
    # wherever an account as a non-null parent_qb_id field, we look for the id
    # of the account with the same company_id and qbd_id = parent_qb_id. then
    # we populate the parent_account_id field with the id of the parent account
    it "can look up and populate a parent account after adding accounts", ->
      @activecellAccount1 =
        id: "52306e72d5ca8d64690000b2"
        company_id: @companyId
        qbd_id: "QB:1"
        name: "Account 1"
        type: "Asset"
        subtype: "Bank"
        account_number: "101"
        current_balance: 30000

      @activecellAccount2 =
        id: "52306e72d5ca8d64690000b3"
        company_id: @companyId
        qbd_id: "QB:2"
        name: "Account 2"
        type: "Asset"
        subtype: "Bank"
        account_number: "102"
        current_balance: 40000
        parent_qb_id: "QB:1"

      resultObjForAccount2 =
        id: "52306e72d5ca8d64690000b3"
        company_id: @companyId
        qbd_id: "QB:2"
        name: "Account 2"
        type: "Asset"
        subtype: "Bank"
        account_number: "102"
        current_balance: 40000
        parent_qb_id: "QB:1"
        parent_account_id: "52306e72d5ca8d64690000b2"

    it "uses the cached account lookup ", ->

#    it "filters comparison to valid Activecell objects", ->
#
#    it "can compare objObjs with Activecell objects", ->
#
#    it "can update an existing object", ->
