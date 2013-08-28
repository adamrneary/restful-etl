process.env.NODE_ENV ||= 'test'
process.env.PORT     ||= 5001

path = require('path')


# TODO: use testing-config (NODE_ENV='test') for database and clear it

request = require('supertest')
app     = require path.join(__dirname, '../../api')
db      = require path.join(__dirname, '../../lib/db')



describe 'ETL api', ->

  before (done)->
    connection = db.conn.connection
    connection.on 'connected', ->
      connection.db.dropDatabase (err)->
        done()


  describe 'Connection', ->

    it 'should raise an error when trying to send empty request', (done)->

      request(app)
        .post('/connection')
        .expect(500)
        .end(done)


    it 'should create and get connection', (done)->


      request(app)
        .post('/connection')
        .send({ name: 'tobi23asasfasdsd22' })
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


