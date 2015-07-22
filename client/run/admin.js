// Generated by CoffeeScript 1.9.3
(function() {
  var Admin, hashChange, hidePages, io;

  io = window.io.connect();

  io.on('message', function(data) {
    return $("#" + data.taskName + "_detail").append(data.message + "<br/>");
  });

  io.on('done', function(data) {
    $("#" + data.taskName + "_message").html(data.message).parent().addClass('has-success');
    return $("#" + data.taskName + "_detail").append("done!");
  });

  io.on('error', function(data) {
    $("#" + data.taskName + "_message").html(data.error.message).parent().addClass('has-error');
    return $("#" + data.taskName + "_detail").html(JSON.stringify(data.error));
  });

  io.on('message', function(data) {
    return console.log("server says: ", data.message);
  });

  Admin = {
    deleteCard: function(cardId) {
      console.log("deleting card " + cardId);
      $('#deleteCard_message').html("working ...").parent().removeClass('has-success').removeClass('has-error');
      $('#deleteCard_detail').html("");
      return io.emit("deleteCard", cardId);
    },
    resetUser: function(userId) {
      console.log("resetting user " + userId);
      $('#resetUser_message').html("working ...").parent().removeClass('has-success').removeClass('has-error');
      $('#resetUser_detail').html("");
      return io.emit("resetUser", userId);
    }
  };

  window.Admin = Admin;

  hidePages = function() {
    return $(".page").hide();
  };

  window.onhashchange = hashChange = function() {
    console.log("showing page " + window.location.hash);
    hidePages();
    return $(window.location.hash).show();
  };

  $(document).ready(function() {
    $('#deleteCard').on('submit', function() {
      Admin.deleteCard($('#deleteCard_id').val());
      return false;
    });
    $('#resetUser').on('submit', function() {
      Admin.resetUser($('#resetUser_id').val());
      return false;
    });
    if (window.location.hash) {
      hashChange();
    }
    return io.emit('ready');
  });

}).call(this);
