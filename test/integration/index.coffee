process.env.NODE_ENV ||= "test"
process.env.PORT     ||= 5001

path = require "path"
nock = require "nock"
_ = require "underscore"
Batch = require("../../lib/batch").Batch
connectionModel = require "../../lib/db/models/connection"

app     = require path.join(__dirname, "../../api")
db      = require path.join(__dirname, "../../lib/db")

describe "Check batch class", ->
  before (done)->
    connection = db.conn.connection
    connection.on "connected", ->
      connection.db.dropDatabase (err)->
        done()

  it "create connection and check batch", (done)->
    connectioin =
      name: "name1"
      provider: "QBO"
      realm: "55555"
      oauth_consumer_key: "0001"
      oauth_consumer_secret: "0002"
      oauth_access_key: "0003"
      oauth_access_secret: "0004"

    options =
      tenant_id: "tenant_id_test"
      source_connection_id: "5242bebbcbf86b9b26000004"
      destination_connection_id: "destination_connection_id_test"
      jobs: [
        extract:
          object: "Bills"
      ,
        extract:
          object: "Account"
      ]

    connectionModel::create connectioin, (err, model) ->
      options.source_connection_id = model._id
      scope = nock("https://services.intuit.com")
        .get("/sb/account/v2/55555")
        .times(2)
        .reply(200, "done");
      batch = new Batch(options)
      batch.run (err, jobs) ->
        done(err) if err
        _.each jobs, (job) ->
          done("not done") if job.extract._data isnt "done"
        done()

