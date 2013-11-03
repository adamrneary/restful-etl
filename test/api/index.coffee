process.env.NODE_ENV ||= 'test'
process.env.PORT     ||= 5001

path = require('path')


request = require('supertest')
app     = require path.join(__dirname, '../../api')
db      = require path.join(__dirname, '../../lib/db')

describe 'ETL connection api', ->
  before (done)->
    connection = db.conn.connection
    connection.on 'connected', ->
      connection.db.dropDatabase (err)->
        done()

  it 'create connection', (done)->
    request(app)
      .post('/connection')
      .send({ name: 'NAME1' })
      .set('Accept', 'application/json')
      .set('Content-type', 'application/json')
      .expect(200)
      .end (done)

  it 'create and get connection', (done)->
    request(app)
      .post('/connection')
      .send({ name: 'NAME2' })
      .set('Accept', 'application/json')
      .set('Content-type', 'application/json')
      .expect(200)
      .end (err, req)->
        return done err if err?
        id = req.body._id
        request(app)
          .get("/connection/#{id}")
          .expect(200)
          .end(done)

  it 'create and change connection', (done)->
    request(app)
      .post('/connection')
      .send({ name: 'NAME3' })
      .set('Accept', 'application/json')
      .set('Content-type', 'application/json')
      .expect(200)
      .end (err, req)->
        return done err if err?
        id = req.body._id
        request(app)
          .put("/connection/#{id}")
          .send({ name: 'NAME3_1' })
          .set('Accept', 'application/json')
          .set('Content-type', 'application/json')
          .expect(200)
          .end(done)

  it 'create and delete connection', (done)->
    request(app)
      .post('/connection')
      .send({ name: 'NAME4' })
      .set('Accept', 'application/json')
      .set('Content-type', 'application/json')
      .expect(200)
      .end (err, req)->
        return done err if err?
        id = req.body._id
        request(app)
          .del("/connection/#{id}")
          .expect(200)
          .end(done)

  it 'get all connections', (done)->
    request(app)
      .get('/connection')
      .expect(200)
      .end(done)

describe 'ETL batch api', ->
  it 'create batch', (done)->
    request(app)
      .post('/batch')
      .expect(200)
      .end (done)

  it 'create and get batch', (done)->
    request(app)
      .post('/batch')
      .expect(200)
      .end (err, req)->
        return done err if err?
        id = req.body._id
        request(app)
          .get("/batch/#{id}")
          .expect(200)
          .end(done)

  it 'get all batch', (done)->
    request(app)
      .get('/batch')
      .expect(200)
      .end(done)

describe 'ETL tenant api', ->
  it 'create tenant', (done)->
    request(app)
      .post('/tenant')
      .send({name: "NAME1"})
      .set('Accept', 'application/json')
      .set('Content-type', 'application/json')
      .expect(200)
      .end (done)

  it 'create and get tenant', (done)->
    request(app)
      .post('/tenant')
      .send({name: "NAME2"})
      .set('Accept', 'application/json')
      .set('Content-type', 'application/json')
      .expect(200)
      .end (err, req)->
        return done err if err?
        id = req.body._id
        request(app)
          .get("/tenant/#{id}")
          .expect(200)
          .end(done)

  it 'create and change tenant', (done)->
    request(app)
      .post('/tenant')
      .send({name: "NAME3"})
      .set('Accept', 'application/json')
      .set('Content-type', 'application/json')
      .expect(200)
      .end (err, req)->
        return done err if err?
        id = req.body._id
        request(app)
          .put("/tenant/#{id}")
          .send({name: "NAME3_1"})
          .set('Accept', 'application/json')
          .set('Content-type', 'application/json')
          .expect(200)
          .end(done)

  it 'create and delete tenant', (done)->
    request(app)
      .post('/tenant')
      .send({name: "NAME4"})
      .set('Accept', 'application/json')
      .set('Content-type', 'application/json')
      .expect(200)
      .end (err, req)->
        return done err if err?
        id = req.body._id
        request(app)
          .del("/tenant/#{id}")
          .expect(200)
          .end(done)

  it 'get all tenant', (done)->
    request(app)
      .get('/tenant')
      .expect(200)
      .end(done)


describe 'ETL schedule api', ->
  it 'create schedule', (done)->
    request(app)
      .post('/schedule')
      .send({cron_time: "* * * * *"})
      .set('Accept', 'application/json')
      .set('Content-type', 'application/json')
      .expect(200)
      .end (done)

  it 'create and get schedule', (done)->
    request(app)
      .post('/schedule')
      .send({cron_time: "* * * * *"})
      .set('Accept', 'application/json')
      .set('Content-type', 'application/json')
      .expect(200)
      .end (err, req)->
        return done err if err?
        id = req.body._id
        request(app)
          .get("/schedule/#{id}")
          .expect(200)
          .end(done)

  it 'create and change schedule', (done)->
    request(app)
      .post('/schedule')
      .send({cron_time: "* * * * *"})
      .set('Accept', 'application/json')
      .set('Content-type', 'application/json')
      .expect(200)
      .end (err, req)->
        return done err if err?
        id = req.body._id
        request(app)
          .put("/schedule/#{id}")
          .send({cron_time: "1 * * * *"})
          .set('Accept', 'application/json')
          .set('Content-type', 'application/json')
          .expect(200)
          .end(done)

  it 'create and delete schedule', (done)->
    request(app)
      .post('/schedule')
      .send({cron_time: "* * * * *"})
      .set('Accept', 'application/json')
      .set('Content-type', 'application/json')
      .expect(200)
      .end (err, req)->
        return done err if err?
        id = req.body._id
        request(app)
          .del("/schedule/#{id}")
          .expect(200)
          .end(done)

  it 'get all schedule', (done)->
    request(app)
      .get('/schedule')
      .expect(200)
      .end(done)
