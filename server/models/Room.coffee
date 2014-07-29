mongoose = require "mongoose"

Room = new mongoose.schema
  number:
    type: String
    required: true
  name:
    type: String
    default: "Room name"
  password:
    type: String


Room.set "autoindex", false

module.exports = Room
