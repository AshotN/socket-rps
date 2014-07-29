http = require 'http'
app = require './express'
config = require './config'

server = http.createServer app
  .listen config.port

console.log "Listening on port: #{config.port}"
module.exports = server
