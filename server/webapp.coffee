passport = require "./passport"
config = require "./config"
app = require "./express"
db = require "./db"


app.get "/", (req, res) ->
  #return res.redirect "/login" unless req.user?

  res.render "index", user: req.user, title: config.title

app.get "/search", (req, res) ->
  res.render "search", title: config.title

app.get "/logout", (req, res) ->
  req.logout()
  res.redirect "/"

app.get "/login", (req, res) ->
  #return res.redirect "/" if req.user?
  res.render "login", title: config.title


# Passport auth routes
app.get "/auth/facebook", passport.authenticate "facebook", scope: ["email"]
app.get "/auth/facebook/callback",
  passport.authenticate "facebook", {successRedirect:"/", falureRedirect:"/login"}
