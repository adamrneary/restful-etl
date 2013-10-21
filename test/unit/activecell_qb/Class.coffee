Class = require("../../../lib/load/providers/activecell_objects/qb/class").class
assert  = require("chai").assert

describe "qb ActiveCell", ->
  describe "class object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

      @qbdObj =
        Name: "Class_6357"
        SubClass: true
        ParentRef:
          value: "QB:1"
          name: "New Construction"
        Active: false
        status: "Synchronized"
        Id: "QB:9"
        SyncToken: "1"
        MetaData:
          CreateTime: "2011-04-05T14:04:36Z"
          LastUpdatedTime: "2013-04-19T09:47:32Z"

      @class= new Class(@companyId)
