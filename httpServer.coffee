http = require "http"

app = require "./express"
server = http.Server app

module.exports = server
