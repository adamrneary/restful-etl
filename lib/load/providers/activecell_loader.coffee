https = require "https"
async = require "async"
_ = require "underscore"
Errors = require "../../Errors"

exports.load = (options = {}, cb) ->
  activeCellData = []
  async.series [
    # load data
    (cb) ->
      requestOptions =
        hostname: "#{options.subdomain}.activecell.com"
        path: "/api/v1/#{options.object.toLowerCase()}.json"
        method: "GET"
        auth: "#{options.username}:#{options.password}"

      req = https.request requestOptions, (res) ->
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
        cb new Errors.IntuitLoadError("", e)
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
      classObj = require("./activecell_objects/qb/#{options.object.toLowerCase()}").class
      Obj = new classObj(options.companyId)
      activeCellData = _.filter activeCellData, (d) ->
        Obj.filter(d)
      sourseData = options.batch.extractData[options.required_object]

      createList = []
      deleteList = []
      updateList = []

      _.each sourseData, (source) ->
        foundIndex = 0
        foundObj = _.find activeCellData, (active, i) ->
          return unless active
          foundIndex = i
          Obj.compare source, active
        if foundObj
          activeCellData[foundIndex] = null
          switch Obj.compare(source, foundObj)
            when "update" then updateList.push Obj.update source, foundObj
        else
          createList.push Obj.transform(source)

      deleteList = _.compact activeCellData

      async.parallel [
        (cb)->
          requestOptions =
            hostname: "#{options.subdomain}.activecell.com"
            path: "/api/v1/#{options.object.toLowerCase()}/"
            method: "PUT"
            auth: "#{options.username}:#{options.password}"

          async.each updateList, (obj, cb) ->
            requestOptions.path += obj.id + ".json"
            req = https.request requestOptions, (res) ->
              cb()
            req.end()
            req.on "error", (e) ->
              cb new Errors.IntuitLoadError("Update object error.", e)
          , (err) ->
            cb(err)
        ,
        (cb)->
          requestOptions =
            hostname: "#{options.subdomain}.activecell.com"
            path: "/api/v1/#{options.object.toLowerCase()}.json"
            method: "POST"
            auth: "#{options.username}:#{options.password}"

          async.each createList, (obj, cb) ->
            req = https.request requestOptions, (res) ->
              cb()
            req.end()
            req.on "error", (e) ->
              cb new Errors.IntuitLoadError("Create object error.", e)
          , (err) ->
            cb(err)
        ,
        (cb)->
          requestOptions =
            hostname: "#{options.subdomain}.activecell.com"
            path: "/api/v1/#{options.object.toLowerCase()}/"
            method: "DELETE"
            auth: "#{options.username}:#{options.password}"

          async.each deleteList, (obj, cb) ->
            requestOptions.path += obj.id + ".json"
            req = https.request requestOptions, (res) ->
              cb()
            req.end()
            req.on "error", (e) ->
              cb new Errors.IntuitLoadError("Delete object error.", e)
          , (err) ->
            cb(err)
      ], (err) ->
        cb(err)
  ], (err) ->
    cb(err)