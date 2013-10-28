Products = require("../../../lib/load/providers/activecell/activecell_objects/products").class
assert  = require("chai").assert

describe "qbd ActiveCell", ->
  describe "default object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

      @qbdObj =
        qbd_id: "QB:95"
        name: "Freight Reimbursement"
        description: "Freight and Delivery Reimbursement"
        income_account_id: "17cc67093475061e3d95369d"
        cogs_account_id: "18cc6709347adfae3d95369d"
        expense_account_id: "19cc6709347adfae3d95369d"
        asset_account_id: "20cc6709347adfae3d95369d"
        deposit_account_id: "21cc6709347adfae3d95369d"
        qb_type: "Other Charge"

      @products = new Products(@companyId)

    it "can compare objObjs with Activecell objects", ->
      existingObj =
        company_id: @companyId
        qbd_id: "QB:95"
        name: "Freight Reimbursement"
        description: "Freight and Delivery Reimbursement"
        income_account_id: "17cc67093475061e3d95369d"
        cogs_account_id: "18cc6709347adfae3d95369d"
        expense_account_id: "19cc6709347adfae3d95369d"
        asset_account_id: "20cc6709347adfae3d95369d"
        deposit_account_id: "21cc6709347adfae3d95369d"
        qb_type: "Other Charge"

      assert.equal @products.compare(
        qbd_id: "QB:95"
        name: "Freight Reimbursement"
        description: "Freight and Delivery Reimbursement"
        income_account_id: "17cc67093475061e3d95369d"
        cogs_account_id: "18cc6709347adfae3d95369d"
        expense_account_id: "19cc6709347adfae3d95369d"
        asset_account_id: "20cc6709347adfae3d95369d"
        deposit_account_id: "21cc6709347adfae3d95369d"
        qb_type: "Other Charge"
      ,
      existingObj
      ), "equal"

      assert.equal @products.compare(
        qbd_id: "QB:95"
        name: "new Freight Reimbursement"
        description: "Freight and Delivery Reimbursement"
        income_account_id: "17cc67093475061e3d95369d"
        cogs_account_id: "18cc6709347adfae3d95369d"
        expense_account_id: "19cc6709347adfae3d95369d"
        asset_account_id: "20cc6709347adfae3d95369d"
        deposit_account_id: "21cc6709347adfae3d95369d"
        qb_type: "Other Charge"
      ,
      existingObj
      ), "update"

      assert.equal @products.compare(
        qbd_id: "QB:951"
        name: "Freight Reimbursement"
        description: "Freight and Delivery Reimbursement"
        income_account_id: "17cc67093475061e3d95369d"
        cogs_account_id: "18cc6709347adfae3d95369d"
        expense_account_id: "19cc6709347adfae3d95369d"
        asset_account_id: "20cc6709347adfae3d95369d"
        deposit_account_id: "21cc6709347adfae3d95369d"
        qb_type: "Other Charge"
      ,
      existingObj
      ), ""

    it "can update an existing object", ->
      @qbdObj.name = "new Name"

      activeCellObj =
        company_id: @companyId
        qbd_id: "QB:95"
        name: "Freight Reimbursement"
        description: "Freight and Delivery Reimbursement"
        income_account_id: "17cc67093475061e3d95369d"
        cogs_account_id: "18cc6709347adfae3d95369d"
        expense_account_id: "19cc6709347adfae3d95369d"
        asset_account_id: "20cc6709347adfae3d95369d"
        deposit_account_id: "21cc6709347adfae3d95369d"
        qb_type: "Other Charge"

      resultObj =
        company_id: @companyId
        qbd_id: "QB:95"
        name: "new Name"
        description: "Freight and Delivery Reimbursement"
        income_account_id: "17cc67093475061e3d95369d"
        cogs_account_id: "18cc6709347adfae3d95369d"
        expense_account_id: "19cc6709347adfae3d95369d"
        asset_account_id: "20cc6709347adfae3d95369d"
        deposit_account_id: "21cc6709347adfae3d95369d"
        qb_type: "Other Charge"

      assert.deepEqual @products.update(@qbdObj, activeCellObj), resultObj
