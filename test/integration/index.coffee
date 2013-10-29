process.env.NODE_ENV ||= "test"
process.env.PORT     ||= 5001

path = require "path"
nock = require "nock"
_ = require "underscore"
fs = require "fs"
async = require "async"
Batch = require("../../lib/batch").Batch
intuitExtractor = require("../../lib/extract/providers/intuit_extractor")
connectionModel = require "../../lib/db/models/connection"

app     = require path.join(__dirname, "../../api")
db      = require path.join(__dirname, "../../lib/db")

describe "Check intuit extractor", ->
  it "create a intuit connection and receive data", (done)->
    connectioin =
      name: "intuit connection"
      provider: "QB"
      oauth_consumer_key: "0001"
      oauth_consumer_secret: "0002"
      oauth_access_key: "0003"
      oauth_access_secret: "0004"
      realm: "12345"

    options =
      tenant_id: "tenant_id_test"
      source_connection_id: "source_connection_id"
      destination_connection_id: "destination_connection_id"
      jobs: [
          type: "extract"
          object: "Account"
      ]

    connectionModel::create connectioin, (err, model) ->
      options.source_connection_id = model._id
      options.destination_connection_id = model._id
      nock("https://qb.sbfinance.intuit.com")
        .get("/v3/company/12345/query?query=%20select%20count(*)%20from%20Account")
        .reply(200, '{"QueryResponse":{"totalCount":1},"time":"2013-10-03T05:10:07.823-07:00"}');

      nock("https://qb.sbfinance.intuit.com")
        .get("/v3/company/12345/query?query=%20select%20*,%20MetaData.CreateTime%20from%20Account%20%20startposition%201%20maxresults%20500")
        .reply(200, '{"QueryResponse":{"Account":[{"name":"tempName"}]},"time":"2013-10-03T05:10:07.823-07:00"}');

      batch = new Batch(options)
      batch.run (err) ->
        if err then done(err)
        else done()

  it "create a intuit connection and receive big data", (done)->
    intuitExtractor.maxResults 1

    connectioin =
      name: "intuit connection 2"
      provider: "QB"
      oauth_consumer_key: "0001"
      oauth_consumer_secret: "0002"
      oauth_access_key: "0003"
      oauth_access_secret: "0004"
      realm: "12345"

    options =
      tenant_id: "tenant_id_test"
      source_connection_id: "source_connection_id"
      destination_connection_id: "destination_connection_id_test"
      jobs: [
          type: "extract"
          object: "Account"
      ]

    connectionModel::create connectioin, (err, model) ->
      options.source_connection_id = model._id
      options.destination_connection_id = model._id
      nock("https://qb.sbfinance.intuit.com")
        .get("/v3/company/12345/query?query=%20select%20count(*)%20from%20Account")
        .reply(200, '{"QueryResponse":{"totalCount":2},"time":"2013-10-03T05:10:07.823-07:00"}');

      nock("https://qb.sbfinance.intuit.com")
        .get("/v3/company/12345/query?query=%20select%20*,%20MetaData.CreateTime%20from%20Account%20%20startposition%201%20maxresults%201")
        .reply(200, '{"QueryResponse":{"Account":[{"name":"tempName1"}]},"time":"2013-10-03T05:10:07.823-07:00"}');

      nock("https://qb.sbfinance.intuit.com")
        .get("/v3/company/12345/query?query=%20select%20*,%20MetaData.CreateTime%20from%20Account%20%20startposition%202%20maxresults%201")
        .reply(200, '{"QueryResponse":{"Account":[{"name":"tempName2"}]},"time":"2013-10-03T05:10:07.823-07:00"}');

      batch = new Batch(options)
      batch.run (err, jobs) ->
        if err then done(err)
        else
          find = (list, item) ->
            _.find list, (obj) ->
              return true if obj.name is item
              return false
          data = batch.extractData.Account
          if find(data, "tempName1") and find(data, "tempName2")
            done()
          else
            done("objects not found")


describe "Extract data from intuit and load it to ActiveCell", ->
  it "extract customers from intuit transform and load to ActiveCell", (done)->
    intuitExtractor.maxResults 500
    intuitConnectioin =
      name: "intuit connection 3"
      provider: "QB"
      oauth_consumer_key: "0001"
      oauth_consumer_secret: "0002"
      oauth_access_key: "0003"
      oauth_access_secret: "0004"
      realm: "12345"

    activeCellConnectioin =
      name: "Active Cell connection"
      provider: "ACTIVECELL"
      subdomain: "sterlingcooper"
      company_id: "company_id:12345"
      username: "don.draper@sterlingcooper.com"
      password: "111111"

    options =
      tenant_id: "tenant_id_test"
      source_connection_id: "source_connection_id"
      destination_connection_id: "destination_connection_id"
      jobs: [
#        type: "extract"
#        object: "Customer"
#      ,
        type: "extract"
        object: "Account"
#      ,
#        type: "load"
#        object: "customers"
#        required_objects:
#          extract: ["Customer"]
      ,
        type: "load"
        object: "accounts"
        required_objects:
          extract: ["Account"]
      ]

    intuitAccountData = ""
    intuitBillData = ""
    intuitCreditMemoData = ""
    intuitCustomerData = ""
    intuitInvoiceData = ""
    intuitItemData = ""
    intuitPaymentData = ""
    intuitPurchaseData = ""
    intuitSalesReceiptData = ""
    intuitVendorData = ""

    activeCellAccountsData = ""
    activeCellCustomersData = ""
    activeCellFinancialTxnsData = ""
    activeCellProductsData = ""
    activeCellVendorsData = ""
    activeCellPeriodsData = ""



    async.series [
      # Extract QB data
      (cb) ->
        fs.readFile "./test/integration/qb_data/Account", (err, data) ->
          intuitAccountData = '{"QueryResponse":{"Account":'+data.toString()+'}}'
          cb(err)
    ,
      (cb) ->
        fs.readFile "./test/integration/qb_data/Bill", (err, data) ->
          intuitBillData = '{"QueryResponse":{"Bill":'+data.toString()+'}}'
          cb(err)
    ,
      (cb) ->
        fs.readFile "./test/integration/qb_data/CreditMemo", (err, data) ->
          intuitCreditMemoData = '{"QueryResponse":{"CreditMemo":'+data.toString()+'}}'
          cb(err)
    ,
      (cb) ->
        fs.readFile "./test/integration/qb_data/Customer", (err, data) ->
          intuitCustomerData = '{"QueryResponse":{"Customer":'+data.toString()+'}}'
          cb(err)
    ,
      (cb) ->
        fs.readFile "./test/integration/qb_data/Invoice", (err, data) ->
          intuitInvoiceData = '{"QueryResponse":{"Invoice":'+data.toString()+'}}'
          cb(err)
    ,
      (cb) ->
        fs.readFile "./test/integration/qb_data/Item", (err, data) ->
          intuitItemData = '{"QueryResponse":{"Item":'+data.toString()+'}}'
          cb(err)
    ,
      (cb) ->
        fs.readFile "./test/integration/qb_data/Payment", (err, data) ->
          intuitPaymentData = '{"QueryResponse":{"Payment":'+data.toString()+'}}'
          cb(err)
    ,
      (cb) ->
        fs.readFile "./test/integration/qb_data/Purchase", (err, data) ->
          intuitPurchaseData = '{"QueryResponse":{"Purchase":'+data.toString()+'}}'
          cb(err)
    ,
      (cb) ->
        fs.readFile "./test/integration/qb_data/SalesReceipt", (err, data) ->
          intuitSalesReceiptData = '{"QueryResponse":{"SalesReceipt":'+data.toString()+'}}'
          cb(err)
    ,
      (cb) ->
        fs.readFile "./test/integration/qb_data/Vendor", (err, data) ->
          intuitVendorData = '{"QueryResponse":{"Vendor":'+data.toString()+'}}'
          cb(err)
    ,
      # Extract ActiveCell data
      (cb) ->
        fs.readFile "./test/integration/activecell_data/accounts", (err, data) ->
          activeCellAccountsData = data.toString()
          cb(err)
    ,
      (cb) ->
        fs.readFile "./test/integration/activecell_data/customers", (err, data) ->
          activeCellCustomersData = data.toString()
          cb(err)
    ,
      (cb) ->
        fs.readFile "./test/integration/activecell_data/financial_txns", (err, data) ->
          activeCellFinancialTxnsData = data.toString()
          cb(err)
    ,
      (cb) ->
        fs.readFile "./test/integration/activecell_data/periods", (err, data) ->
          activeCellPeriodsData = data.toString()
          cb(err)
    ,
      (cb) ->
        fs.readFile "./test/integration/activecell_data/products", (err, data) ->
          activeCellProductsData = data.toString()
          cb(err)
    ,
      (cb) ->
        fs.readFile "./test/integration/activecell_data/vendors", (err, data) ->
          activeCellVendorsData = data.toString()
          cb(err)
    ,
      # create Intuit connection
      (cb) ->
        connectionModel::create intuitConnectioin, (err, model) ->
          options.source_connection_id = model._id

          # mocking Intuit answers
            # Account
          nock("https://qb.sbfinance.intuit.com")
            .get("/v3/company/12345/query?query=%20select%20count(*)%20from%20Account")
            .reply(200, '{"QueryResponse":{"totalCount":5},"time":"2013-10-03T05:10:07.823-07:00"}')
          nock("https://qb.sbfinance.intuit.com")
            .get("/v3/company/12345/query?query=%20select%20*,%20MetaData.CreateTime%20from%20Account%20%20startposition%201%20maxresults%20500")
            .reply(200, intuitAccountData);
#
#          nock("https://qb.sbfinance.intuit.com")
#            .get("/v3/company/12345/query?query=%20select%20count(*)%20from%20Customer")
#            .reply(200, '{"QueryResponse":{"totalCount":20},"time":"2013-10-03T05:10:07.823-07:00"}')
#          nock("https://qb.sbfinance.intuit.com")
#            .get("/v3/company/12345/query?query=%20select%20*,%20MetaData.CreateTime%20from%20Customer%20%20startposition%201%20maxresults%20500")
#            .reply(200, intuitCustomerData);


          cb(err)
    ,
      # create ActiveCell connection
      (cb) ->
        connectionModel::create activeCellConnectioin, (err, model) ->
          options.destination_connection_id = model._id
          # mocking ActiveCell answers
          nock("https://sterlingcooper.activecell.com")
            .get("/api/v1/accounts.json")
            .reply(200, activeCellAccountsData)
#          nock("https://sterlingcooper.activecell.com")
#            .get("/api/v1/customers.json")
#            .reply(200, activeCellCustomersData)
          cb(err)
    ,
      # mocking ActiveCell answers
      (cb) ->
        fs.readFile "./test/integration/activecell_data/accounts_create", (err, data) ->
          createObjects = JSON.parse data.toString()
          _.each createObjects, (obj) ->
            nock("https://sterlingcooper.activecell.com")
              .post("/api/v1/accounts.json")
              .reply(201);
          cb(err)
    ,
      (cb) ->
        fs.readFile "./test/integration/activecell_data/accounts_delete", (err, data) ->
          deleteObjects = JSON.parse data.toString()
          _.each deleteObjects, (obj) ->
            nock("https://sterlingcooper.activecell.com")
              .delete("/api/v1/accounts/#{obj.id}.json")
              .reply(204)
          cb(err)
    ,
      (cb) ->
        fs.readFile "./test/integration/activecell_data/accounts_update", (err, data) ->
          updateObjects = JSON.parse data.toString()
          _.each updateObjects, (obj) ->

            nock("https://sterlingcooper.activecell.com")
              .put("/api/v1/accounts/#{obj.id}.json")
              .reply(200)
          cb(err)
    ,
      (cb) ->
        fs.readFile "./test/integration/activecell_data/customers_create", (err, data) ->
          createObjects = JSON.parse data.toString()
          _.each createObjects, (obj) ->
            nock("https://sterlingcooper.activecell.com")
              .post("/api/v1/customers.json")
              .reply(201);
          cb(err)
    ,
      (cb) ->
        fs.readFile "./test/integration/activecell_data/customers_delete", (err, data) ->
          deleteObjects = JSON.parse data.toString()
          _.each deleteObjects, (obj) ->
            nock("https://sterlingcooper.activecell.com")
              .delete("/api/v1/customers/#{obj.id}.json")
              .reply(204)
          cb(err)
    ,
      (cb) ->
        fs.readFile "./test/integration/activecell_data/customers_update", (err, data) ->
          updateObjects = JSON.parse data.toString()
          _.each updateObjects, (obj) ->
            nock("https://sterlingcooper.activecell.com")
              .put("/api/v1/customers/#{obj.id}.json")
              .reply(200)
          cb(err)
    ,
      (cb) ->
        batch = new Batch(options)
        batch.run (err) ->
          cb(err)
    ], (err) ->
      done(err)
