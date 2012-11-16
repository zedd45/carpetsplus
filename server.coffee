express = require 'express'
stylus  = require 'stylus'
nib     = require 'nib'


app = express()

  
compile = (str, path) ->
  stylus(str)
    .define('url', stylus.url(
          paths : [__dirname + "/public"]
          limit : 10000
        ))
        .set('filename', path)
        .set('compress', true)
        .use(nib())


app.configure ->
  app.set 'view engine', 'jade'
  app.set 'views', __dirname + '/views'
  app.use express.static __dirname + '/public'
  app.use app.router
  app.use stylus.middleware
    src      : __dirname + '/public'
    compile  : compile
  

app.configure 'development', ->
  app.use express.errorHandler()
  app.use(express.logger('dev'))
  

app.get '/', (req, res) ->
  res.render 'index.jade', 
    title: 'Welcome to Carpets Plus'
  
  



app.listen 3000
console.log 'app started at 3000'