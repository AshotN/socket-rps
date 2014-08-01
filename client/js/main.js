$(document).ready(function(){
  socket = io.connect();

  $('.message').hide();

  socket.on('message', function(data){
    var el = $('.message');
    if (data.error){
      el.addClass('error');
    }
    el.fadeIn()
      .text(data.message)
      .fadeOut(2000);
  });
  //Get to your room NOW
  socket.on('room-created', function(data){
    window.location.replace("/room");
  });


  $('.setup-button').click(function(){
    var val = $('.setup-user').val();
    console.log($(".check").is(":checked"));
    if($(".check").is(":checked")){
      socket.emit('setup-user', {username: val});
    }
    else {
      socket.emit('dummy');
    }
  });

  socket.on('setup-result', function(data){ //Server replied
    if (data.error){
      $('.message').text(data.error);
    }
    else {
      $('.message').text("Saved!");
      setTimeout(function(){
        location = '/'; // Username is set now go
      }, 2000);
    }
  });

  // Join room
  $('.join-button').click(function(){
    var val = $('.join-room').val();
    if (val.length < 4){
      $('.message').fadeIn()
        .addClass('error')
        .text('Error: Room ID is required')
        .fadeOut(2000);
    }
    else{
      socket.emit('join-room', {roomid: val});
    }
  });

  $('.create-button').click(function(){
    $('.create').slideToggle(500);
    $('.create-button').toggleClass('active');
  });

  $('.create-room-button').click(function(){
    var name = $('.create-room').val();
    var pass = $('.create-room-password').val();
    socket.emit('create-room', {name: name, pass: pass});
  });


});
