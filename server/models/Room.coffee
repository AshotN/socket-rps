mongoose = require "mongoose"

Room = new mongoose.Schema

  roomid:
    type: String
    required: true
    unique: true
  name:
    type: String
    default: "Room name"
  password:
    type: String


Room.set "autoindex", false

module.exports = Room
