app = require('showcase').app(__dirname)
request = require('supertest')

{isAuth, docco, getSections} = require('showcase')

app.start()

# Generate docco documenation
docco(files: '/src/coffee/*', output: '/public/docs', root: __dirname, layout: 'linear')
