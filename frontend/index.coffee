gfm = require  'gfm'
app = require('showcase').app(__dirname)
request = require('supertest')

{isAuth, docco, getSections} = require('showcase')

app.get '/', isAuth, (req, res) ->
  res.render 'pages/iframe', url: '/home/connections.html'

app.get '/tests', isAuth, (req, res) ->
  res.render 'pages/iframe', url: '/test_runner.html'

app.get '/documentation', isAuth, (req, res) ->
  res.render 'pages/iframe', url: '/docs/connection.html'

app.start()

# Generate docco documenation
docco(files: '/../lib/db/models/*.coffee', output: '/public/docs', root: __dirname, layout: 'parallel')
docco(files: '/../docs/api/*.md', output: '/public/home', root: __dirname, layout: 'linear')
