Accounts = require("../../../lib/load/providers/activecell/activecell_objects/accounts").class
assert  = require("chai").assert

describe "qbd ActiveCell", ->
  describe "default object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

      @qbdObj =
        qbd_id: "QB:147"
        name: "Chase Operating"
        type: "Asset"
        subtype: "Bank"
        account_number: "10400"
        current_balance: 12823.22
        parent_qb_id: "QB:37"

      @accounts = new Accounts(@companyId)

    it "can compare objObjs with Activecell objects", ->
      existingObj =
        company_id: @companyId
        qbd_id: "QB:147"
        name: "Chase Operating"
        type: "Asset"
        subtype: "Bank"
        account_number: "10400"
        current_balance: 12823.22
        parent_qb_id: "QB:37"

      assert.equal @accounts.compare(
        qbd_id: "QB:147"
        name: "Chase Operating"
        type: "Asset"
        subtype: "Bank"
        account_number: "10400"
        current_balance: 12823.22
        parent_qb_id: "QB:37"
      ,
      existingObj
      ), "equal"

      assert.equal @accounts.compare(
        qbd_id: "QB:147"
        name: "new Chase Operating"
        type: "Asset"
        subtype: "Bank"
        account_number: "10400"
        current_balance: 12823.22
        parent_qb_id: "QB:37"
      ,
      existingObj
      ), "update"

      assert.equal @accounts.compare(
        qbd_id: "QB:148"
        name: "Chase Operating"
        type: "Asset"
        subtype: "Bank"
        account_number: "10400"
        current_balance: 12823.22
        parent_qb_id: "QB:37"
      ,
      existingObj
      ), ""

    it "can update an existing object", ->
      @qbdObj.name = "new Name"

      activeCellObj =
        company_id: @companyId
        qbd_id: "QB:147"
        name: "new Chase Operating"
        type: "Asset"
        subtype: "Bank"
        account_number: "10400"
        current_balance: 12823.22
        parent_qb_id: "QB:37"

      resultObj =
        company_id: @companyId
        qbd_id: "QB:147"
        name: "new Name"
        type: "Asset"
        subtype: "Bank"
        account_number: "10400"
        current_balance: 12823.22
        parent_qb_id: "QB:37"

      assert.deepEqual @accounts.update(@qbdObj, activeCellObj), resultObj
