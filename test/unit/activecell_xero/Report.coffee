describe "xero ActiveCell", ->
  describe "Payment object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

      @xeroObj =
        ReportID: "BankStatement"
        ReportName: "Bank Statement"
        ReportType: "BankStatement"
        ReportTitles:
          ReportTitle: [
            "Bank Statement",
            "Business Bank Account",
            "Demo Company (AU)",
            "From 1 August 2013 to 20 August 2013"
          ]
        ReportDate: "20 August 2013"
        UpdatedDateUTC: "2013-08-20T03:39:39.5658282Z"
        Rows:
          Row: [
              RowType: "Header"
              Cells:
                Cell: [
                  Value: "Date"
                  ,
                  Value: "Description"
                  ,
                  Value: "Reference"
                  ,
                  Value: "Reconciled"
                  ,
                  Value: "Source"
                  ,
                  Value: "Amount"
                  ,
                  Value: "Balance"
                ]
            ,
              RowType: "Section"
              Rows:
                Row: [
                  RowType: "Row"
                  Cells:
                    Cell: [
                        Value: "2013-08-01T00:00:00"
                      ,
                        Value: "Opening Balance"
                      ,
                        Value: "-1792.15"
                    ]
                  ,
                    RowType: "Row",
                    Cells:
                      Cell: [
                        Value: "2013-08-04T00:00:00"
                        ,
                        Value: "Melbourne Mags"
                        ,
                        Value: "Eft  "
                        ,
                        Value: "Yes"
                        ,
                        Value: "Import"
                        ,
                        Value: "-21.90"
                        ,
                        Value: "-1814.05"
                      ]
                  ,
                  RowType: "Row"
                  Cells:
                    Cell: [
                        Value: "2013-08-04T00:00:00"
                      ,
                        Value: "MCO Cleaning"
                      ,
                        Value: "Yes"
                      ,
                        Value: "Import"
                      ,
                        Value: "-170.50"
                      ,
                        Value: "-1984.55"
                    ]
                ]
          ]

    it "can transform a xeroObj in order to create a new Activecell obj", ->
