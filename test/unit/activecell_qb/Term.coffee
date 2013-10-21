Term = require("../../../lib/load/providers/activecell_objects/qb/term").class
assert  = require("chai").assert

describe "qb ActiveCell", ->
  describe "term object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

      @qbdObj =
        Name: "TermForV3Testing-1373582383811"
        Active: true
        Type: "DATE_DRIVEN"
        DiscountPercent: 4.0000000
        DayOfMonthDue: 1
        DueNextMonthDays: 2
        DiscountDayOfMonth: 3
        domain: "QBO"
        sparse: false
        Id: "13"
        SyncToken: "0"
        MetaData:
          CreateTime: "2013-07-11T15:36:39-07:00"
          LastUpdatedTime: "2013-07-11T15:36:39-07:00"

      @term = new Term(@companyId)