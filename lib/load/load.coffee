moment = require "moment"
errorModel = require "../../lib/db/models/error"
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
        batch_id: options.batch.options._id
        company_id: options.companyId
        source_connection_id: options.batch.options.source_connection_id
        destination_connection_id: options.batch.options.destination_connection_id
        batch_start: options.batch.options.created_at
        message: JSON.stringify(err)
      errorModel::create(message)
    cb(err)

  loadObjects options, loadCb

module.exports = load