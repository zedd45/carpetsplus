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
        .import('nib')


app.configure ->
  this.set 'view engine', 'jade'
  this.set 'views', __dirname + '/views'
  this.use app.router
  this.use stylus.middleware
    src      : __dirname + '/public'
    compile  : compile
  
  # must come after stylus or will not recompile   
  this.use express.static __dirname + '/public'
  

app.configure 'development', ->
  app.use express.errorHandler()
  app.use(express.logger('dev'))
  

app.get '/', (req, res) ->
  res.render 'index', 
    title: 'Welcome to Carpets Plus'
  
  
  
app.get '/contact_us_to_get_your_carpet_cleaned', (req, res) ->
  res.render 'contact',
    title: 'Contact Carpets Plus to get your carpet cleaned'



# NOTE: technically the main script isn't supposed to start the server:
# http://package.json.jit.su/
app.listen 3000
console.log 'app started at 3000'