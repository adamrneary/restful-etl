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
  extractObjects options, cb

module.exports = extract