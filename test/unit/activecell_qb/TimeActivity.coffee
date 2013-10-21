TimeActivity = require("../../../lib/load/providers/activecell_objects/qb/time_activity").class
assert  = require("chai").assert

describe "qb ActiveCell", ->
  describe "timeActivity object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

      @qbdObj =
        TxnDate: "2013-01-28"
        NameOf: "Vendor"
        VendorRef:
          value:"61"
          name:"TimeActivity Vendor9QrXF1BF"
        CustomerRef:
          value: "60"
          name: "TimeActivity Customer2UGu2cKx"
        DepartmentRef:
          value: "3"
          name: "TimeActivity Departmenttgv5wci9"
        ItemRef:
          value: "4"
          name: "TimeActivity ItemwTsh51e2"
        ClassRef:
          value: "100100000000000321202"
          name: "TimeActivity KlasskuzA8UVd"
        BillableStatus: "Billable"
        Taxable: true
        HourlyRate: 251
        BreakHours: 1
        BreakMinutes: 0
        StartTime: "2013-01-28T08:00:00-08:00"
        EndTime: "2013-01-28T17:00:00-08:00"
        Description: "Single activity time sheet"
        domain: "QBO"
        sparse: false
        Id: "2"
        SyncToken: "0"
        MetaData:
          CreateTime: "2013-07-11T15:12:14-07:00"
          LastUpdatedTime: "2013-07-11T15:12:14-07:00"

      @timeActivity = new TimeActivity(@companyId)