app = require('showcase').app(__dirname)
request = require('supertest')

{isAuth, docco, getSections} = require('showcase')

app.get '/', isAuth, (req, res) ->
  res.render 'pages/index'

app.get '/tests', isAuth, (req, res) ->
  res.render 'pages/iframe', url: '/test_runner.html'

app.get '/documentation', isAuth, (req, res) ->
  res.render 'pages/iframe', url: '/docs/index.html'

app.start()

# Generate docco documenation
docco(files: '/src/coffee/*.coffee', output: '/public/docs', root: __dirname, layout: 'parallel')
