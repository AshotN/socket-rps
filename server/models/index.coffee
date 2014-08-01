mongoose = require "mongoose"

exports.User = mongoose.model "User", require "./User"
exports.Room = mongoose.model "Room", require "./Room"
