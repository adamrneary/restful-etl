moment = require "moment"
activecellLoader = require("./providers/activecell_loader").load

loadObjects = (options = {}, cb) ->
  switch options.provider.toUpperCase()
    when "ACTIVECELL"
      activecellLoader options, cb

load = (options = {}, cb) ->
  if options.since
    date = moment options.since
    switch options.grain
      when "monthly"
        date.month(0)
    options.since = date
  loadObjects options, cb

module.exports = load