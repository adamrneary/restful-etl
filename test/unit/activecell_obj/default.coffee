Default = require("../../../lib/load/providers/activecell/activecell_objects/default").Default
assert  = require("chai").assert

describe "qbd ActiveCell", ->
  describe "default object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

      @qbdObj =
        qbd_id: "QB:399"
        name: "American Express Settlement"

      @default = new Default(@companyId)

    it "filters comparison to valid Activecell objects", ->
      assert.ok @default.filter {company_id: @companyId, qbd_id:"qbd:1234"}
      assert.notOk @default.filter {company_id: @companyId}

    it "can compare objObjs with Activecell objects", ->
      existingObj =
        company_id: @companyId
        qbd_id: "QB:399"
        name: "name1"

      assert.equal @default.compare(
        qbd_id: "QB:399"
        name: "name1"
      ,
      existingObj
      ), "equal"

      assert.equal @default.compare(
        qbd_id:"QB:399"
        name: "new name"
      ,
      existingObj
      ), "update"

      assert.equal @default.compare(
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

      assert.deepEqual @default.update(@qbdObj, activeCellObj), resultObj
