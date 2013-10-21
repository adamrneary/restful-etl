CompanyInfo = require("../../../lib/load/providers/activecell_objects/qb/company_info").class
assert  = require("chai").assert

describe "qb ActiveCell", ->
  describe "companyInfo object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

      @qbdObj =
          CompanyName: "Stage_Nirvana_CompInfo"
          LegalName: "Stage_Nirvana_CompInfo_Legal"
          CompanyAddr:
            Line1: "2500 Garcia Ave"
            Line2: "2nd cross,3rd street"
            Line3: "CA 94010"
            City: "MountainView"
            CountrySubDivisionCode: "CA"
            PostalCode: "94010"
          LegalAddr:
            Line1: "2500 Garcia Ave"
            Line2: "2nd cross,3rd street"
            City: "MountainView"
            CountrySubDivisionCode: "CA"
            PostalCode: "94010"
          PrimaryPhone:
            FreeFormNumber: "650-890-9876"
          CompanyFileName: "Stage_Nirvana_CompInfo"
          FlavorStratum: "bel_stratum"
          SampleFile: false,
          CompanyUserId: "183058671"
          CompanyStartDate: "2013-05-27"
          EmployerId: "12-1234567"
          FiscalYearStartMonth: "January"
          TaxYearStartMonth: "January"
          QBVersion: "23 0 5 4"
          Fax:
            FreeFormNumber: "650-890-9876"
          Email:
            Address: "nirvana@intu.com"
          WebAddr:
            URI: "www.nirvanainto.com"
          LastSyncTime: "2013-05-27T01:56:55Z"
          domain: "QBDT",
          Id: "255535841"
          SyncToken: "1"
          MetaData:
            CreateTime: "2013-05-27T01:56:09.660Z"
            LastUpdatedTime: "2013-05-27T01:56:55.330Z"
      @CompanyInfo= new CompanyInfo(@companyId)
