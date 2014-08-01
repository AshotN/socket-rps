io = require "socket.io"
cookieParser = require 'cookie-parser'
db = require "./db"
config = require "./config"
server = require "./httpserver"
sessionStore = require './sessionstore'
passportSocketIO = require 'passport.socketio'
io = io.listen server

User = db.models.User
Room = db.models.Room

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

makeid = ->
  text = ""
  possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
  i = 0
  while i < 5
    text += possible.charAt(Math.floor(Math.random() * possible.length))
    i++
  return text#NEVER RELY ON IMPLICIT RETURNS, THEY ARE SATAN SPAWN

io.sockets.on "connection", (socket) ->
  console.log "socket connected"
  socket.email = socket.request.user.email

  socket.on "setup-user", (data) ->
    User.update {email: socket.email}, {username: data.username}, (err, user) ->
      return socket.emit "setup-result", {error: "username taken"} if err?
      socket.emit "setup-result", {success: true}

  socket.on "join-room", (data) ->
    Room.findOne roomid: data.roomid, (err, room) ->
      return socket.emit "message", {error: true, message: "Room not found"} unless room?

  socket.on "create-room", (data) ->
    pass = String data.pass
    name = String data.name
    Room.create {name: name, password: pass, roomid: makeid()}, (err, room) ->
      console.log err, room
      return socket.emit "message", {error: true, message: "Unexpected error"} if err?
      socket.emit "room-created", roomid: room.roomid






