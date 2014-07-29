$(document).ready(function(){
  socket = io.connect();

  socket.emit('ready', {test: true});
  setTimeout(function(){
    socket.emit('test', {test: true});
  }, 2000);

  $('.setup-button').click(function(){
    val = $('.setup-user').val();
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
});
