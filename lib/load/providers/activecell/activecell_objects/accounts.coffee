Default = require("./default").Default
utils = require "../utils/utils"

class Accounts extends Default
  constructor: (@company_id) ->
    @compareFields [ "qbd_id", "name", "type", "subtype", "account_number", "current_balance", "parent_qb_id"]

module.exports.class = Accounts

