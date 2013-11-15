_ = require "underscore"
Default = require("./default").Default
utils = require "../utils/utils"

class Vendor extends Default
  transform: (qbdObj, extractData, loadData, loadResultData, cb) =>
    messages = []
    result = []
    obj = super qbdObj, extractData, loadData, loadResultData
    utils.satisfyDependencies(obj, extractData, loadData, loadResultData)
    result.push obj

    unless _.all(result, (obj) => not @_checkRequiredFields(obj))
      messages.push
        subtype: "error"
        message: "required fields does not exist"
        objType: "Vendor"
        source_obj: qbdObj
        result_obj: _.map result, (obj) =>
          obj: obj
          missing_fields: @_checkRequiredFields(obj)
      cb messages if cb
      return []

    cb messages if cb
    result

module.exports.class = Vendor