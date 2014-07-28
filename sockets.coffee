jwt = require "json-web-token"
server = require "./httpServer"
config = require "./config"
io = require("socket.io")(server)


validateToken = (token, username, callback) ->
	# decode
	jwt.decode config.secret, token, (err_, decode) ->
    	return console.error(err_)  if err_
    	if username is decode
    		console.log "A"
    		return callback true
    	console.log "#{username}:#{decode}"
    	return callback false

rooms = 
	1: 
		password: "ashot"
		name: 1
	2:
		password: "ashot"
		name: 2

roomcount = 1




io.on "connection", (socket) ->

	socket.broadcast.emit "connection", "Connected"


	socket.on "makeroom", (data) ->
		if data is null or typeof data is 'undefined'
			return console.log "NULL!!!"

		token = data.token
		username = data.username

		validateToken token, username, (result) ->
			auth = result

		if !auth
			return socket.emit "Not Authorized"


		#Continue For Makeroom stuff

	socket.on "joinroom", (data) ->
		if data is null or typeof data is 'undefined'
			return console.log "NULL!!!"

		joinid = data.id
		password = data.password
		username = data.username
		token = data.token
		auth = false
		socket.username = "Hego555"
		console.log "CALLED"

		
		validateToken token, username, (result) ->
			auth = result
			console.log result

		if !auth
			console.log "No #{auth}"
			return socket.emit "Not Authorized"

		console.log "B: #{socket.id}"
		console.log "A: #{io.sockets.sockets[socket.id]}"

		if rooms[joinid] #If room exists
			if rooms[joinid].password is password #if password is valid
				clients = io.sockets.adapter.rooms[joinid] #get clients in room
				clientcount = 0
				if typeof clients != 'undefined' #if not undefined(to avoid error)
					clientcount = Object.keys(clients).length;
				
				if clientcount < 2 #if less than 2 people in room, join it!
					socket.join(joinid);
					#socket.username = joinid #set here <<<<<<<<<<<<
					console.log "Set: #{socket.username}"
					console.log "#{username} Connected To #{joinid}"
					socket.emit "redirect", {url: "/room"}
			else
				return console.log "Invalid Password To Room #{joinid} By #{username}"


		else
			return console.log "#{username} No Room(#{joinid}) Found!"	
		

	#Client sends roomjoin when /room loads
	socket.on "roomjoin", (data, acknowledge) ->
		###
		if data is null or typeof data is 'undefined'
			return console.log "NULL!!!"

		username = data.username
		token = data.token
		auth = false

		validateToken token, username, (result) ->
			auth = result
			console.log result

		if !auth
			console.log "No #{auth}"
			return socket.emit "Not Authorized"	
		###
		console.log "C: #{socket.username}" #Prints undefined
		console.log socket.id

		





	socket.on "ready", (data, acknowledge) ->
		if data is null or typeof data is 'undefined'
			return console.log "NULL!!!"

		username = data.username
		token = data.token
		auth = false

		validateToken token, username, (result) ->
			auth = result
			console.log result

		if !auth
			console.log "No #{auth}"
			return socket.emit "Not Authorized"	

		acknowledge "ready"
