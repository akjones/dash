# Module dependencies
express = require 'express'
http = require 'http'
path = require 'path'

# Routes
home = require './routes/home'
widgets = require './routes/widgets'
data = require './routes/data'
edit = require './routes/edit'

app = express()

app.configure () ->
    app.set 'port', process.env.PORT || 3000
    app.set 'views', __dirname + '/views'
    app.set 'view engine', 'ejs'
    app.use express.favicon './assets/favicon.ico'
    app.use express.logger('dev')
    app.use express.bodyParser()
    app.use express.methodOverride()
    app.use express.cookieParser('your secret here')
    app.use express.session()
    app.use app.router
    app.use require('connect-assets')()
    app.use express.static path.join(__dirname, 'public')

app.configure 'development', () ->
    app.use express.errorHandler({ dumpExceptions: true, showStack: true })

app.configure 'production', ->
    app.use express.errorHandler()

app.get '/', home.dashboard
app.get '/widgets', widgets.get
app.get '/widget/:type/data', data.get
app.get '/widget/:type/data/:params', data.get
app.get '/edit', edit.page
app.post '/uploadConfig', edit.upload_file

http.createServer(app).listen app.get('port'), () ->
    console.log 'Express server listening on port ' + app.get('port')
