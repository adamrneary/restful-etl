https = require "https"
async = require "async"
_ = require "underscore"

exports.load = (options = {}, cb) ->
  activeCellData = []
  async.series [
    # load data
    (cb) ->
      options_temp =
        hostname: "#{options.subdomain}.activecell.com"
        path: "/api/v1/#{options.object.toLowerCase()}.json"
        method: "GET"
        auth: "#{options.username}:#{options.password}"

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
        if not options.batch.extractData[options.required_object]
          setTimeout(waitObjects, 1000)
        else
          cb()
      waitObjects()
    ,
    # compare objects
    (cb) ->
      Customers = require("./activecell_objects/qb/#{options.object.toLowerCase()}").class
      Obj = new Customers(options.companyId)
      activeCellData = _.filter activeCellData, (d) ->
        Obj.filter(d)
      sourseData = options.batch.extractData[options.required_object]

      createList = []
      deleteList = []
      updateList = []

      _.each sourseData, (source) ->
        foundIndex = 0
        foundObj = _.find activeCellData, (active, i)->
          foundIndex = i
          Obj.compare source, active
        if foundObj
          activeCellData[foundIndex] = null
          switch Obj.compare source, foundObj
            when "update" then updateList.push Obj.update source, foundObj
        else
          createList.push Obj.transform(source)

      deleteList = _.compact activeCellData

      console.log "updateList", updateList
      console.log "createList", createList
      console.log "deleteList", deleteList
      cb()
  ], (err) ->
    cb(err)