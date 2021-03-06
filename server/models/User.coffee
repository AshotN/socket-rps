mongoose = require "mongoose"

User = new mongoose.Schema

  username:
    type: String
    unique: true
  id:
    type: String
    required: true
    unique: true
  email:
    type: String
    required: true
    unique: true
  name:
    type: String
  image:
    type: String
  provider:
    type: String

User.set "autoindex", false

module.exports = User
