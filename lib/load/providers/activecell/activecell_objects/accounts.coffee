Default = require("./default").Default
utils = require "../utils/utils"

class Accounts extends Default
  constructor: (@company_id) ->
    @compareFields [ "qbd_id", "name", "type", "sub_type", "account_number", "current_balance", "parent_account_id"]

module.exports.class = Accounts

