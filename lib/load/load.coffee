moment = require "moment"
activecellLoader = require("./providers/activecell/activecell_loader").load

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
  loadCb = (err) ->
    if err
      message =
        type: "load"
        message: JSON.stringify(err)
        objType: options.object
      options.batch.errors[options.object] ||= {error: true, messages: []}
      options.batch.errors[options.object].messages.push message
    cb(err)

  loadObjects options, loadCb

module.exports = load