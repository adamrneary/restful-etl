Preferences = require("../../../lib/load/providers/activecell_objects/qb/preferences").class
assert  = require("chai").assert

describe "qb ActiveCell", ->
  describe "preferences object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

      @qbdObj =
        AccountingInfoPrefs:
          UseAccountNumbers: true
          RequiresAccounts: true
          ClassTrackingPerTxn: true
          AutoJournalEntryNumber: true
          FirstMonthOfFiscalYear: "January"
          TaxYearMonth: "January"
          TaxForm: "1255"
        AdvancedInventoryPrefs:
          FIFOEnabled: true
          FIFOEffectiveDate: "2013-04-24"
        ProductAndServicesPrefs:
          InventoryAndPurchaseOrder: true
          UOM: "MultiplePerItem"
        SalesFormsPrefs:
          UsingProgressInvoicing: true
          AllowEstimates: true
          AutoApplyCredit: false
          AutoApplyPayments: true
          PrintItemWithZeroAmount: true
          DefaultShipMethodRef:
            value: "QB:4"
          DefaultMarkup: 0.0
          TrackReimbursableExpensesAsIncome: true
          UsingSalesOrders: true
          UsingPriceLevels: true
        VendorAndPurchasesPrefs:
          DefaultMarkup: 0.0
          DaysBillsAreDue: 10
          DiscountAccountRef:
            value: "QB:125"
        TimeTrackingPrefs:
          WorkWeekStartDate: "Monday"
          TimeTrackingEnabled: true
        TaxPrefs:
          UsingSalesTax: true
          TaxRateRef:
            value: "QB:46"
          NonTaxableSalesTaxCodeRef:
            value: "QB:2"
          TaxableSalesTaxCodeRef:
            value: "QB:1"
        FinanceChargesPrefs:
          AnnualInterestRate: 10.0
          MinFinChrg: 5.0
          CalcFinChrgFromTxnDate: false
          AssessFinChrgForOverdueCharges: true
          FinChrgAccountRef:
            value: "QB:77"
        CurrencyPrefs:
          MultiCurrencyEnabled: false
          HomeCurrency:
            value: "QB:0"
        ReportPrefs:
          ReportBasis: "Accrual"

      @preferences = new Preferences(@companyId)