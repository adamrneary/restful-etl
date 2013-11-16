moment = require "moment"
intuitExtractor = require("./providers/intuit_extractor").extract
xeroExtractor = require("./providers/xero_extractor").extract

extractObjects = (options = {}, cb) ->
  switch options.provider.toUpperCase()
    when "QB"
      intuitExtractor options, cb
    when "XERO"
      xeroExtractor options, cb

extract = (options = {}, cb) ->
  if options.since
    date = moment options.since
    switch options.grain
      when "monthly"
        date.month(0)
    options.since = date

  extractCb = (err, data) ->
    if err
      message =
        type: "extract"
        message: JSON.stringify(err)
        objType: options.object
      options.batch.errors[options.object] ||= {error: true, messages: []}
      options.batch.errors[options.object].messages.push message
    cb(err, data)

  extractObjects options, extractCb

module.exports = extract