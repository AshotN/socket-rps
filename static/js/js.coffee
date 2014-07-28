$(document).ready ->

	socket = io("http://hego555.no-ip.org:5555")

	arrow=false

	socket.on "redirect", (data) ->
	  console.log "redirect to #{data.url}"
	  window.location = data.url

	$("#makesettings").click ->
		$(".eachsetting").slideToggle(600)
		if(arrow)
			$(".arrow").attr("src", "images/down.png")
			arrow=false
		else
			$(".arrow").attr("src", "images/up.png")
			arrow=true

	$("#join").click ->
		roomnum = prompt "Whats The Room Name!"
		socket.emit "joinroom", {username: user, id: roomnum, password: "ashot", token: token}

	$("#make").click ->
		socket.emit "makeroom", {password: $(".password").val()}

	$(".headermessage").click ->
		if $(this).text() == "Login"
			$("#login").fadeIn("fast")
			$("#backgroundDarkener").show()

	$("#backgroundDarkener").click ->
		$(this).fadeOut("fast")
		$("#login").fadeOut("fast")

	$("#loginbutton").click (event) ->
	  console.log("A")
	  username = $("#username").val()
	  password = $("#password").val()
	  if (username is "" or !username?) or (password is "" or !password?)
	    console.log "No Credentials"
	  else
	    console.log("D")
	    console.log "#{username}:#{password}"
	    hashSHA512 = CryptoJS.SHA512(password).toString()
	    hash = CryptoJS.MD5(hashSHA512).toString()
	    $.post("handlelogin",
	      user: username
	      pass: hash
	    , (data) ->
	      if data.length > 0
	        console.log("B")
	        $("#loginoutput").html data
	        $("#loginoutput").show "fast"
	      else
	        console.log("C")
	        $("#loginoutput").html "Error"
	        $("#loginoutput").show "fast"
	      return
	    ).done (data) ->
	      console.log "success"
	      if data.indexOf("Welcome") >= 0
	            $("#backgroundDarkener").fadeOut("fast")
	            $("#login").fadeOut("fast")
	            $(".headermessage").html "Welcome #{username}"
	      return


	

  return
