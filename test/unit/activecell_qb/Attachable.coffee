Attachable = require("../../../lib/load/providers/activecell_objects/qb/attachable").class
assert  = require("chai").assert

describe "qb ActiveCell", ->
  describe "attachable object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

      @qbdObj =
        Lat: "25.293189023"
        Long: "-21.3253249834"
        Note: "This is an attached note."
        PlaceName "Mountain View"
        Tag: "Create Attachable with Note"
        domain: "QBO"
        sparse: false
        Id:"200900000000000008541"
        SyncToken: 0
        MetaData:
          CreateTime: "2013-03-14T16:00:26-07:00"
          LastUpdatedTime: "2013-03-14T16:00:26-07:00"
        AttachableRef:[
          EntityRef:
            value: 1058,
            type: "Invoice"
          IncludeOnSend: false
        ]

      @attachable= new Attachable(@companyId)
