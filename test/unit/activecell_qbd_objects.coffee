qbd_customers = require("../../lib/load/providers/activecell_objects/qbd/customers").object

assert  = require("chai").assert

describe "qbd ActiveCell", ->

  describe "Customers object", ->
    it "can transform a qbdObj in order to create a new Activecell obj", ->
      qbdObj =
        Id:"qbd:1234"
        DisplayName: "name1"

      resultObj =
        company_id:"1234"
        qbd_id:"qbd:1234"
        name: "name1"

      assert.deepEqual qbd_customers.create("1234", qbdObj), resultObj

    it "filters comparison to valid Activecell objects", ->
      assert.ok qbd_customers.filter "1234", {company_id:"1234", qbd_id:"qbd:1234"}
      assert.notOk qbd_customers.filter "1234", {company_id:"1234"}

    it "can compare objObjs with Activecell objects", ->
      existingObj =
        company_id: "1234"
        qbd_id: "qbd:1234"
        name: "name1"

      assert.equal qbd_customers.compare("1234",
        Id: "qbd:1234"
        DisplayName: "name1"
      ,
        existingObj
      ), "equal"

      assert.equal qbd_customers.compare("1234",
        Id:"qbd:1234"
        DisplayName: "new name"
      ,
        existingObj
      ), "update"

      assert.equal qbd_customers.compare("1234",{
        Iid:"qbd:234"
        DisplayName: "name1"
      ,
        existingObj
      ), ""


    it "can update an existing object", ->
      qbdObj =
        Id:"qbd:1234"
        DisplayName: "new Name"

      activeCellObj =
        company_id:"1234"
        qbd_id:"qbd:1234"
        name: "name1"

      resultObj =
        company_id:"1234"
        qbd_id:"qbd:1234"
        name: "new Name"

      assert.deepEqual qbd_customers.update("1234", qbdObj, activeCellObj), resultObj
