$(document).ready ->

	socket = io("http://hego555.no-ip.org:5555")

	socket.emit "roomjoin", {username: user, token: token}, (data) ->
		#Response Information!


	$(".ready").click (event) ->
		$(this).attr disabled: true
		socket.emit "ready", {username: user, token: token}, (data) ->
			if data is "ready"
			  console.log "readyreply: #{data}"
			  $(".youready").text "Ready"
			else
			  console.log "Not Ready?"
			  $(".youready").text "Error!?"


  return