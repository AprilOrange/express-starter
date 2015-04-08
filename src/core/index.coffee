express = require 'express'
app = express()
swig = require 'swig'
bodyParser = require 'body-parser'
logger = require 'connect-logger'
session = require 'express-session'
RedisStore = require('connect-redis')(session)
config = require './config'
routes = require './routes'
global.C = config

module.exports = (root) ->
    
  sess =
    name: config.session.name
    secret: config.session.key
    store: new RedisStore()
    resave: false
    saveUninitialized: false
    cookie: 
      maxAge: 86400 * 1000 * 365
      httpOnly: false

  app.use session sess
  app.use bodyParser.json()
  app.use bodyParser.urlencoded
    extended: false

  if app.get('env') is 'development'
    app.use logger()
    app.set 'view cache', false
    swig.setDefaults cache: false

  app.use '/static', express.static('public')
  app.engine 'html', swig.renderFile
  app.set 'view engine', 'html'
  app.set 'views', root + '/views'

  auted_required = (req, res, next) ->
    if req.session.user
      res.locals.user = req.session.user
      next()
    else
      res.redirect '/signin'
      return
    return

  auted_optional = (req, res, next) ->
    res.locals.user = req.session.user
    next()
    return

  app.get '/', routes.index

  port = config.port || 3746

  app.listen port, ->
    console.log config.site.name + ' is running at http://localhost:' + port