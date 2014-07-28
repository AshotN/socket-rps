express = require "express"
bodyParser = require "body-parser"
session = require "express-session"

app = express()

app.set "view engine", "jade"
app.set "views", __dirname + "/views"
app.use express.static __dirname + "/static"
# parse application/x-www-form-urlencoded
app.use bodyParser.urlencoded()
# parse application/json
app.use bodyParser.json()

app.use session({secret: 'thisisthetopsecretpasswordthatnoonewilleverguessktydianaubettercome2thepoolfriday'})


module.exports = app
