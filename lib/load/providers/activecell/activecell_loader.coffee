https = require "https"
async = require "async"
_ = require "underscore"
Errors = require "../../../Errors"
utils = require "./utils/utils"

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
              options.batch.loadData[options.object] = data.slice(0)
              cb err

      req.end()
      req.on "error", (e) ->
        cb new Errors.IntuitLoadError("", e)
    ,
    # waiting for extract required objects
    (cb) ->
      unless options.required_objects.extract
        cb()
        return
      waitObjects = () ->
        if (not _.any options.required_objects.extract, (object) ->
          not _.isUndefined(options.batch.extractData[object]))
          setTimeout(waitObjects, 100)
        else
          cb()
      waitObjects()
    ,
    # waiting for load required objects
    (cb) ->
      unless options.required_objects.load
        cb()
        return
      waitObjects = () ->
        if (_.any options.required_objects.load, (object) ->
          not _.isUndefined(options.batch.loadData[object]))
          setTimeout(waitObjects, 100)
        else
          cb()
      waitObjects()
  ,
    (cb) ->
      extractData = options.batch.extractData
      loadData = options.batch.loadData
      loadResultData = options.batch.loadResultData
      resultData = []
      async.series [
        # compare objects
          (cb) ->
            objNames = utils.getQBObjByObjName options.object
            sourseData = []
            _.each objNames, (objName) ->
              return unless options.batch.extractData[objName]
              classObj = require("./qb/#{objName}").class
              Obj = new classObj(options.companyId)
              _.each options.batch.extractData[objName], (obj) ->
                sourseData = sourseData.concat Obj.transform(obj, extractData, loadData, loadResultData)

            classObj = require("./activecell_objects/#{options.object.toLowerCase()}").class
            Obj = new classObj(options.companyId)
            activeCellData = _.filter activeCellData, (d) ->
              Obj.filter(d)
            resultData = activeCellData.slice(0)
            createList = []
            deleteList = []
            updateList = []

            _.each sourseData, (sourceObject) ->
              foundIndex = 0
              foundObj = _.find activeCellData, (activeCellObject, i) ->
                return unless activeCellObject
                foundIndex = i
                Obj.compare sourceObject, activeCellObject
              if foundObj
                activeCellData[foundIndex] = null
                switch Obj.compare(sourceObject, foundObj)
                  when "update"
                    updatedObject = Obj.update(sourceObject, foundObj)
                    updateList.push updatedObject
                    resultData[foundIndex] = updatedObject
              else
                createList.push sourceObject

            deleteList = _.compact activeCellData

            _.each deleteList, (deletedObject) ->
              _.each resultData, (object, i) ->
                resultData[i] = null if deletedObject is object
            resultData = _.compact resultData

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
              (cb)-> #TODO: Added created objects to the resultData
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
        ,
          # waiting for load result required objects
          (cb) ->
            unless options.required_objects.load_result
              cb()
              return
            waitObjects = () ->
              if (_.any options.required_objects.load_result, (object) ->
                not _.isUndefined(options.batch.loadResultData[object]))
                setTimeout(waitObjects, 100)
              else
                cb()
            waitObjects()
        ,
          #satisfy dependencies if needed
          (cb) ->
            updateList = []
            _.each resultData, (obj) ->
              updateList.push obj if utils.satisfyDependencies(obj, extractData, loadData, loadResultData)

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
              if err then cb(err)
              else
                options.batch.loadResultData[options.object] = resultData
                cb()
      ], (err) ->
        cb(err)
  ], (err) ->
    cb(err)