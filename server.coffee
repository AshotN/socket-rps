mysql = require "mysql"
crypto = require "crypto"
jwt = require "json-web-token"

config = require "./config"
server = require "./httpServer"
app = require "./express"
require "./sockets"


server.listen config.port
console.log "Starting on port: #{config.port}"


connection = mysql.createConnection
  host     : "localhost"
  user     : "root"
  password : "jonisweird"
  database : "rps"

checkLoggedIn = (ID, request, callback)->

	if !request.session.username? and !request.session.password? and !request.session.ID?
	  callback "Not Logged In!", false

	connection.query "SELECT Username,Password FROM `Users` WHERE `ID` = '#{ID}'", (err, rows, fields) ->
		return callback err, false if err?

		return callback("Not Logged In", false) unless rows[0]

		if rows[0].Username == request.session.username and rows[0].Password == request.session.password
			#return true
			return callback "success", true
		else
			console.log "The end of stack, shouldn't have reached here, check the code!!!"


app.get "/", (req, res) ->
	
	#req.session.loggedin = false
	ip = req.connection.remoteAddress
	if req.session.ID?
		ID = req.session.ID
		checkLoggedIn ID, req, (err, result) ->
			req.session.loggedin = result
			if result
				res.render "index.jade", {user: req.session.username, token: req.session.token}
			else
				res.render "index.jade"
	else
		res.render "index.jade"
		

	if req.session.ID?
		console.log "Connection From #{ip} As #{req.session.username}"
	else
		console.log "Connection From #{ip}"

app.get "/room", (req, res) ->
	if !req.session.ID? #No session, gtfo
		console.log "GTFO"
		res.writeHead 302,
		"Location" : "/"
		return res.end()

	ID = req.session.ID
	checkLoggedIn ID, req, (err, result) ->
		if !result
			console.log "LEAVE"
			res.writeHead 302,
			"Location" : "/"
			return res.end()

		console.log "Welcome To Room!"
		enemy = "BluLev"#Place Holder
		res.render "room.jade", {user: req.session.username, token: req.session.token, enemy: enemy}

app.get "/handlelogin", (request, response) ->
	response.writeHead 302,
	 	"location" : "/"

	 response.end()

app.post "/handlelogin", (request, response) ->



	if !request.body?
		#response.writeHead 200
		response.end "done."
		throw "User Not Defined!"

	username = request.body.user
	hashMD5 = request.body.pass
	#response.end("#{username}:#{password}")
	
	#hash = crypto.createHash('SHA512').update(password).digest('hex')
	#hashMD5 = crypto.createHash('md5').update(hash).digest('hex')
	
	connection.query "SELECT ID FROM `Users` WHERE `Username` = '#{username}' AND `Password`='#{hashMD5}'", (err, rows, fields) ->
		if err?
			console.log "Err: #{err}"
			throw err
		if !rows[0]?
			response.write "Incorrect Info"
		else
	
			request.session.username = username
			request.session.password = hashMD5

			request.session.ID = rows[0].ID
			# encode
			jwt.encode config.secret, username, (err, token) ->
			  return console.error(err)  if err
			  request.session.token = token
	  
			console.log "#{username} logged in"
			response.end "Welcome"


			




process.on "uncaughtException", (error) ->
  console.log "ERROR!!!"
  console.log error.stack
  return

connection.connect (err) ->
	if err
		console.error "error connecting:  #{err.stack}"
		return
	console.log "connected as id  #{connection.threadId}"
	return

