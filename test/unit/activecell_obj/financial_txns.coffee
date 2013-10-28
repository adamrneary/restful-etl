FinancialTxns = require("../../../lib/load/providers/activecell/activecell_objects/financial_txns").class
assert  = require("chai").assert

describe "qbd ActiveCell", ->
  describe "default object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

      @qbdObj =
        amount_cents: 160000
        account_id: "19cc6709347adfae3d95369d"
        company_id: @companyId
        qbd_id: "QB:213"
        vendor_id: "27cc67093475061e3d95369d"
        transaction_date: "2013-02-05"
        source: "QB:Bill"
        is_credit: false
        period_id: "27cc67093475061e3d95369d"

      @financialTxns = new FinancialTxns(@companyId)

    it "can compare objObjs with Activecell objects", ->
      existingObj =
        company_id: @companyId
        amount_cents: 160000
        account_id: "19cc6709347adfae3d95369d"
        company_id: @companyId
        qbd_id: "QB:213"
        vendor_id: "27cc67093475061e3d95369d"
        transaction_date: "2013-02-05"
        source: "QB:Bill"
        is_credit: false
        period_id: "27cc67093475061e3d95369d"

      assert.equal @financialTxns.compare(
        amount_cents: 160000
        account_id: "19cc6709347adfae3d95369d"
        company_id: @companyId
        qbd_id: "QB:213"
        vendor_id: "27cc67093475061e3d95369d"
        transaction_date: "2013-02-05"
        source: "QB:Bill"
        is_credit: false
        period_id: "27cc67093475061e3d95369d"
      ,
      existingObj
      ), "equal"

      assert.equal @financialTxns.compare(
        amount_cents: 160500
        account_id: "19cc6709347adfae3d95369d"
        company_id: @companyId
        qbd_id: "QB:213"
        vendor_id: "27cc67093475061e3d95369d"
        transaction_date: "2013-02-05"
        source: "QB:Bill"
        is_credit: false
        period_id: "27cc67093475061e3d95369d"
      ,
      existingObj
      ), "update"

      assert.equal @financialTxns.compare(
        amount_cents: 160000
        account_id: "19cc6709347adfae3d95369d"
        company_id: @companyId
        qbd_id: "QB:214"
        vendor_id: "27cc67093475061e3d95369d"
        transaction_date: "2013-02-05"
        source: "QB:Bill"
        is_credit: false
        period_id: "27cc67093475061e3d95369d"
      ,
      existingObj
      ), ""

    it "can update an existing object", ->
      @qbdObj.amount_cents = 160500

      activeCellObj =
        amount_cents: 160000
        account_id: "19cc6709347adfae3d95369d"
        company_id: @companyId
        qbd_id: "QB:213"
        vendor_id: "27cc67093475061e3d95369d"
        transaction_date: "2013-02-05"
        source: "QB:Bill"
        is_credit: false
        period_id: "27cc67093475061e3d95369d"

      resultObj =
        company_id: @companyId
        amount_cents: 160500
        account_id: "19cc6709347adfae3d95369d"
        company_id: @companyId
        qbd_id: "QB:213"
        vendor_id: "27cc67093475061e3d95369d"
        transaction_date: "2013-02-05"
        source: "QB:Bill"
        is_credit: false
        period_id: "27cc67093475061e3d95369d"

      assert.deepEqual @financialTxns.update(@qbdObj, activeCellObj), resultObj
