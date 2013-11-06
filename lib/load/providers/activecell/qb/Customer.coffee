_ = require "underscore"
Default = require("./default").Default
utils = require "../utils/utils"

class Customer extends Default
  transform: (qbdObj, extractData, loadData, loadResultData, cb) =>
    messages = []
    result = []
    obj = super qbdObj, extractData, loadData, loadResultData
    utils.satisfyDependencies(obj, extractData, loadData, loadResultData)
    result.push obj

    unless _.all(result, (obj) => @_checkRequiredFields(obj))
      messages.push
        type: "error"
        message: "required fields does not exist"
        objType: "Customer"
        obj: qbdObj
      cb messages if cb
      return []

    cb messages if cb
    result

module.exports.class = Customer