io = require "socket.io"
cookieParser = require 'cookie-parser'
db = require "./db"
config = require "./config"
server = require "./httpserver"
sessionStore = require './sessionstore'
passportSocketIO = require 'passport.socketio'
io = io.listen server

User = db.models.User

io.set 'authorization', passportSocketIO.authorize
  cookieParser: cookieParser
  key: config.session.name
  secret: config.session.secret
  store: sessionStore
  fail: (data, message, critical, accept) ->
    console.log 'io session failed'
    accept null, false
  success: (data, accept) ->
    console.log 'io session success'
    accept null, true


io.sockets.on "connection", (socket) ->
  console.log "socket connected"
  socket.email = socket.request.user.email

  socket.on "setup-user", (data) ->
    User.update {email: socket.email}, {username: data.username}, (err, user) ->
      return socket.emit "setup-result", {error: "username taken"} if err?
      socket.emit "setup-result", {success: true}

  socket.on "dummy", ->
    console.log "I GOT IT DUMMY"




