Default = require("./default").Default
utils = require "../utils/utils"

class Accounts extends Default
  constructor: (@company_id) ->
    @compareFields [ "qbd_id", "account_id", "vendor_id", "customer_id", "product_id", "source", "is_credit", "period_id", "transaction_date", "amount_cents"]

module.exports.class = Accounts

