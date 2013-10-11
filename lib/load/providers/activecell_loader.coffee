https = require "https"
async = require "async"
_ = require "underscore"

exports.load = (options = {}, cb) ->

  activeCellData = []
  async.series [
    # load data
    (cb) ->
      options_temp =
        hostname: "sterlingcooper.activecell.com"
        path: "/api/v1/#{options.object.toLowerCase()}.json"
        method: "GET"
        auth: "#{options.oauth_consumer_key}:#{options.oauth_consumer_secret}"

      req = https.request options_temp, (res) ->
        data = ""
        res.on 'data', (d) ->
          data += d.toString()
        res.on 'end', (d) ->
          err = null
          try
            data = JSON.parse data
          catch e
            data = []
            err = e
          finally
              activeCellData = data
              cb err

      req.end()
      req.on "error", (e) ->
        cb e
    ,
    # waiting for required objects
    (cb) ->
      waitObjects = () ->
        wait = _.any options.required_objects, (object) ->
          not options.batch.extractData[object]
        if wait
          setTimeout(waitObjects, 50)
        else
          cb()
      waitObjects()
    ,
    # compare objects
    (cb) ->
      # coming soon
      cb()
  ], (err) ->
    cb(err)














