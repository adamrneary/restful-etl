Default = require("./default").Default
utils = require "../utils/utils"

class Products extends Default
  constructor: (@company_id) ->
    @compareFields [ "qbd_id", "name", "description", "income_account_id", "cogs_account_id", "expense_account_id", "asset_account_id", "deposit_account_id", "qb_type"]

module.exports.class = Products

