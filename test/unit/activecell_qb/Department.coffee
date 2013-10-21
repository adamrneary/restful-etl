Department = require("../../../lib/load/providers/activecell_objects/qb/department").class
assert  = require("chai").assert

describe "qb ActiveCell", ->
  describe "department object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

      @qbdObj =
        Name: "Marketing Department"
        SubDepartment: false
        FullyQualifiedName: "Marketing Department"
        Active: true
        domain: "QBO"
        sparse: false
        Id: "2"
        SyncToken: "0"
        MetaData:
          CreateTime: "2013-08-13T11:52:48-07:00"
          LastUpdatedTime: "2013-08-13T11:52:48-07:00"
      @department= new Department(@companyId)
