request = require "request"
async = require "async"
_ = require "underscore"
message = require("../../../message").message
config = require '../../../../config'
Errors = require "../../../Errors"
errorModel = require "../../../db/models/error"
utils = require "./utils/utils"

exports.load = (options = {}, cb) ->
  activeCellData = []
  async.series [
    # load data
    (cb) ->
      if options.batch.stopped
        cb()
        return
      message options?.tenant_id, "job status", {type: options?.type, batch_id: options?.batch?.options?._id, name: options?.object, err: null, status: "in process"}
      request
        method: "GET"
        uri: "#{config.activecell_protocol}://#{options.subdomain}.#{config.activecell_domain}/api/v1/#{options.object.toLowerCase()}.json?token=#{options.token}"
      , (err, res, data) ->
        if err
          options.batch.stopped = true
          cb new Errors.IntuitLoadError("Get objects #{options.object} error.", err)

        unless res?.statusCode is 200
          options.batch.stopped = true
          cb new Errors.IntuitLoadError("Get objects #{options.object} invalid status code: #{res?.statusCode}", err)
        else
          activeCellData = JSON.parse(data)
          options.batch.loadData[options.object] = activeCellData.slice(0)
          options.batch.loadResultData[options.object] = options.batch.loadData[options.object] if options.object is "periods"
          cb()
    ,
    # waiting for extract required objects
    (cb) ->
      if options.batch.stopped
        cb()
        return
      message options.tenant_id, "job status", {type: options?.type, batch_id: options?.batch?.options?._id, name: options?.object, err: null, status: "pending"}
      if options.object is "periods"
        cb()
        return
      unless options.required_objects?.extract
        cb()
        return
      waitObjects = () ->
        if options.batch.stopped
          cb()
          return
        if (_.any options.required_objects.extract, (object) ->
          _.isUndefined(options.batch.extractData[object]))
          setTimeout(waitObjects, 100)
        else
          cb()
      waitObjects()
    ,
    # waiting for load required objects
    (cb) ->
      if options.batch.stopped
        cb()
        return
      message options.tenant_id, "job status", {type: options?.type, batch_id: options?.batch?.options?._id, name: options?.object, err: null, status: "pending"}
      if options.object is "periods"
        cb()
        return
      unless options.required_objects?.load
        cb()
        return
      waitObjects = () ->
        if options.batch.stopped
          cb()
          return
        if (_.any options.required_objects.load, (object) ->
          _.isUndefined(options.batch.loadData[object]))
          setTimeout(waitObjects, 100)
        else
          cb()
      waitObjects()
    ,
    # waiting for load result required objects
    (cb) ->
      if options.batch.stopped
        cb()
        return
      message options.tenant_id, "job status", {type: options?.type, batch_id: options?.batch?.options?._id, name: options?.object, err: null, status: "pending"}
      if options.object is "periods"
        cb()
        return
      unless options.required_objects?.load_result
        cb()
        return
      waitObjects = () ->
        if options.batch.stopped
          cb()
          return
        if (_.any options.required_objects.load_result, (object) ->
          _.isUndefined(options.batch.loadResultData[object]))
          setTimeout(waitObjects, 100)
        else
          cb()
      waitObjects()
  ,
    (cb) ->
      if options.batch.stopped
        cb()
        return
      message options.tenant_id, "job status", {type: options?.type, batch_id: options?.batch?.options?._id, name: options?.object, err: null, status: "in process"}
      printMessages = (messages)->
        _.each messages, (message) ->
          message.source_obj = JSON.stringify(message.source_obj)
          _.each message.result_obj, (obj) ->
            obj.obj = JSON.stringify(obj.obj)
          errorModel::create(message)

      if options.object is "periods"
        cb()
        return
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
                sourseData = sourseData.concat Obj.transform(obj, extractData, loadData, loadResultData, printMessages)

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
                async.each updateList, (obj, cb) ->
                  if options.batch.stopped
                    cb()
                    return
                  request
                    method: "PUT"
                    uri: "#{config.activecell_protocol}://#{options.subdomain}.#{config.activecell_domain}/api/v1/#{options.object.toLowerCase()}/#{obj.id}.json?token=#{options.token}"
                    json: obj
                  , (err, res, body) ->
                    if err
                      options.batch.stopped = true
                      cb new Errors.IntuitLoadError("Update object error.", err)

                    unless res?.statusCode is 200
                      options.batch.stopped = true
                      cb new Errors.IntuitLoadError("Update invalid status code: #{res?.statusCode}", err)
                    else
                      cb()
                , (err) ->
                  cb(err)
            ,
              (cb)->
                async.each createList, (obj, cb) ->
                  if options.batch.stopped
                    cb()
                    return
                  request
                    method: "POST"
                    uri: "#{config.activecell_protocol}://#{options.subdomain}.#{config.activecell_domain}/api/v1/#{options.object.toLowerCase()}.json?token=#{options.token}"
                    json: obj
                  , (err, res, body) ->
                    if err
                      options.batch.stopped = true
                      cb new Errors.IntuitLoadError("Create object error.", err)

                    unless res?.statusCode is 200
                      options.batch.stopped = true
                      cb new Errors.IntuitLoadError("Create invalid status code: #{res?.statusCode}", err)
                    else
                      resultData.push body
                      cb()
                , (err) ->
                  cb(err)
            ,
              (cb)->
                async.each deleteList, (obj, cb) ->
                  if options.batch.stopped
                    cb()
                    return
                  request
                    method: "DELETE"
                    uri: "#{config.activecell_protocol}://#{options.subdomain}.#{config.activecell_domain}/api/v1/#{options.object.toLowerCase()}/#{obj.id}.json?token=#{options.token}"
                  , (err, res, body) ->
                    if err
                      options.batch.stopped = true
                      cb new Errors.IntuitLoadError("Delete object error.", err)

                    unless res?.statusCode is 200
                      options.batch.stopped = true
                      cb new Errors.IntuitLoadError("Delete invalid status code: #{res?.statusCode}", err)
                    else
                      cb()
                , (err) ->
                  cb(err)
            ], (err) ->
              cb(err)
        ,
          #satisfy dependencies if needed
          (cb) ->
            if options.batch.stopped
              cb()
              return
            message options.tenant_id, "job status", {type: options?.type, batch_id: options?.batch?.options?._id, name: options?.object, err: null, status: "in process"}
            updateList = []
            tmpLoadResultData = _.clone loadResultData
            tmpLoadResultData[options.object] = resultData
            _.each resultData, (obj) ->
              updateList.push obj if utils.satisfyDependencies(obj, extractData, loadData, tmpLoadResultData)
            async.each updateList, (obj, cb) ->
              if options.batch.stopped
                cb()
                return
              request
                method: "PUT"
                uri: "#{config.activecell_protocol}://#{options.subdomain}.#{config.activecell_domain}/api/v1/#{options.object.toLowerCase()}/#{obj.id}.json?token=#{options.token}"
                json: obj
              , (err, res, body) ->
                if err
                  options.batch.stopped = true
                  cb new Errors.IntuitLoadError("Update object error.", err)

                unless res?.statusCode is 200
                  options.batch.stopped = true
                  cb new Errors.IntuitLoadError("Update invalid status code: #{res?statusCode}", err)
                else
                  cb()
            , (err) ->
              if err then cb(err)
              else
                loadResultData[options.object] = resultData
                cb()
      ], (err) ->
        cb(err)
  ], (err) ->
    cb(err)