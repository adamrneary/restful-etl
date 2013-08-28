gfm = require  'gfm'
app = require('showcase').app(__dirname)
request = require('supertest')

{isAuth, docco, getSections} = require('showcase')

app.get '/', isAuth, (req, res) ->
  res.render 'pages/index'

app.get '/tests', isAuth, (req, res) ->
  res.render 'pages/iframe', url: '/test_runner.html'

app.get '/documentation', isAuth, (req, res) ->
  res.render 'pages/iframe', url: '/docs/connection.html'

app.start()

# Generate docco documenation
docco(files: '/../lib/db/models/*.coffee', output: '/public/docs', root: __dirname, layout: 'parallel')

## Generate gfm documenation
#gfm.generate '/../docs/', (error) ->
#  console.log error if error
