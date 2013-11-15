Customers = require("../../../lib/load/providers/activecell/activecell_objects/customers").class
assert  = require("chai").assert

describe "qbd ActiveCell", ->
  describe "default object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

      @qbdObj =
        qbd_id: "QB:399"
        name: "American Express Settlement"

      @customers = new Customers(@companyId)

    it "can compare objObjs with Activecell objects", ->
      existingObj =
        company_id: @companyId
        qbd_id: "QB:399"
        name: "name1"

      assert.equal @customers.compare(
        qbd_id: "QB:399"
        name: "name1"
      ,
      existingObj
      ), "equal"

      assert.equal @customers.compare(
        qbd_id:"QB:399"
        name: "new name"
      ,
      existingObj
      ), "update"

      assert.equal @customers.compare(
        qbd_id:"QB:399x"
        name: "name1"
      ,
      existingObj
      ), ""

    it "can update an existing object", ->
      @qbdObj.name = "new Name"

      activeCellObj =
        company_id: @companyId
        qbd_id: "QB:399"
        name: "name1"

      resultObj =
        company_id: @companyId
        qbd_id: "QB:399"
        name: "new Name"

      assert.deepEqual @customers.update(@qbdObj, activeCellObj), resultObj
