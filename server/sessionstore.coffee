sessionstore = require "sessionstore"
config = require "./config"

module.exports = sessionstore.createSessionStore
  type: "mongoDb"
  host: config.mongo.host # optional
  port: config.mongo.port # optional
  dbName: config.mongo.sessionDb # optional
  collectionName: "sessions" # optional
 