describe "xero ActiveCell", ->
  describe "Organisation object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

      @xeroObj =
        APIKey: "PV1PS57LYQ7VDJYTGCUI99A6YJI1WZ"
        Name: "Demo Company (NZ)"
        LegalName: "Demo Company (NZ)"
        PaysTax: "true"
        Version: "NZ"
        OrganisationType: "COMPANY"
        BaseCurrency: "NZD"
        CountryCode: "NZ"
        IsDemoCompany: "true"
        OrganisationStatus: "ACTIVE"
        TaxNumber: "101-2-303"
        FinancialYearEndDay: "31"
        FinancialYearEndMonth: "3"
        PeriodLockDate: "2009-09-30T00:00:00"
        CreatedDateUTC: "2012-02-19T18:31:02.66"
        OrganisationEntityType: "COMPANY"
        Timezone: "NEWZEALANDSTANDARDTIME"
        ShortCode: "!23eYt"
        Addresses:
          Address:
            AddressType: "POBOX"
            AddressLine1: "3 Market Place"
            AddressLine2: "Twizel 7901"
            City: "Twizel"
            PostalCode: "7901"
            Country: "New Zealand"
            AttentionTo: "Bentley Rhythm Ace"
        ExternalLinks:
          ExternalLink: [
              LinkType: "Facebook"
              Url: "http://facebook.com/Xero.Accounting"
            ,
              LinkType: "Twitter"
              Url: "http://twitter.com/xeroapi"
            ,
              LinkType: "GooglePlus"
              Url: "https://plus.google.com/u/0/105727595143346068928/"
            ,
              LinkType: "LinkedIn"
              Url: "http://www.linkedin.com/company/xero"
          ]
        PaymentTerms:
          Bills:
            Day: "5"
            Type: "OFCURRENTMONTH"
          Sales:
            Day: "20"
            Type: "OFFOLLOWINGMONTH"

    it "can transform a xeroObj in order to create a new Activecell obj", ->
