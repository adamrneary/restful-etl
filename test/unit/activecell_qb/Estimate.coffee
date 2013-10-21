Estimate = require("../../../lib/load/providers/activecell_objects/qb/estimate").class
assert  = require("chai").assert

describe "qb ActiveCell", ->
  describe "estimate object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

      @qbdObj =
        domain: "QBO"
        sparse: false
        Id: "96"
        SyncToken: "0"
        MetaData:
          CreateTime: "2013-03-14T11:04:00-07:00"
          LastUpdatedTime: "2013-03-14T11:04:00-07:00"
        CustomField:[
          Name: "Custom 1"
          Type: "StringType"
          ,
          Name: "Custom 2"
          Type: "StringType"
          ,
          Name: "Custom 3"
          Type: "StringType"
        ]
        DocNumber: "1009"
        TxnDate: "2013-03-13"
        PrivateNote: "Private Note text"
        TxnStatus: "Pending"
        Line:[
          Id: "1"
          LineNum: 1
          Amount: 20.00
          DetailType: "SalesItemLineDetail"
          SalesItemLineDetail:
            ItemRef:
              value: "1"
              name: "Sales"
            TaxCodeRef:
              value: "NON"
          ,
          Amount: 20.00
          DetailType: "SubTotalLineDetail"
          SubTotalLineDetail: { }
        ]
        TxnTaxDetail:
          TotalTax: 0
        CustomerRef:
          value: "1"
          name: "Customer1 Test"
        BillAddr:
          Id: "62"
          Line1: "garcia ave"
          City: "mountain view"
          Country: "usa"
          CountrySubDivisionCode: "ca"
          PostalCode: "94043"
          Lat: "37.4262864"
          Long: "-122.0945241"
        ShipAddr:
          Id: "63"
          Line1: "garcia ave"
          City: "mountain view"
          Country: "usa"
          CountrySubDivisionCode: "ca"
          PostalCode: "94043"
          Lat: "37.4262864"
          Long: "-122.0945241"
        TotalAmt: 20.00
        ApplyTaxAfterDiscount: false
        PrintStatus: "NeedToPrint"
        EmailStatus: "NotSet"

      @estimate= new Estimate(@companyId)
