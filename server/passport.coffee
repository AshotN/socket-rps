mongoose = require 'mongoose'
passport = require "passport"
FacebookStrategy = require("passport-facebook").Strategy

db = require './db'
config = require './config'

User = db.models.User


handleFunction = (token, tokenSecret, profile, cb) ->
  console.log profile

  User.findOne {username:profile.username}, (err, user) ->
    console.log err if err?
    return cb err if err?
    profileUpdate =
      email: profile._json.email
      id: String profile._json.id
      name: profile._json.name
      image: "https://graph.facebook.com/#{profile._json.username}/picture"
      provider: "facebook"
    if user?
      user.set profileUpdate
      user.save cb
    else
      User.create profileUpdate, (err, doc) ->
        console.log err if err?
        return cb err if err?
        cb null, doc


strategy = new FacebookStrategy
  clientID: config.facebook.clientID
  clientSecret: config.facebook.clientSecret
  callbackURL: config.facebook.callback
, handleFunction

passport.use strategy

passport.use strategy

passport.serializeUser (user, cb) ->
  cb null, user.id

passport.deserializeUser (id, cb) ->
  User.findOne {id: id}, cb


module.exports = passport