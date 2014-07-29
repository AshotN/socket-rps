io = require "socket.io"
config = require "./config"
server = require "./httpserver"
cookieParser = require 'cookie-parser'
sessionStore = require './sessionstore'
passportSocketIO = require 'passport.socketio'
io = io.listen server


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
