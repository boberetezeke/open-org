// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .


var current_user_id;
var mock_login = true;

$(function() {
  var watch_callbacks = {
    loggedInUser: current_user_id,
    onlogin: function(assertion) {
      // A user has logged in! Here you need to:
      // 1. Send the assertion to your backend for verification and to create a session.
      // 2. Update your UI.
      if (current_user_id == "") {
        $.ajax({ /* <-- This example uses jQuery, but you can use whatever you'd like */
          type: 'POST',
          url: '/user_sessions/create', // This is a URL on your website.
          data: {assertion: assertion},
          success: function(res, status, xhr) { window.location.reload(); },
          error: function(res, status, xhr) { alert("login failure" + res); }
        });
      }
    },
    onlogout: function() {
      // A user has logged out! Here you need to:
      // Tear down the user's session by redirecting the user or making a call to your backend.
      // Also, make that loggedInUser will get set to null on the next page load.
      // (That's a literal JavaScript null. Not false, 0, or undefined. null.)
      if (current_user_id != "") {
        $.ajax({
          type: 'POST',
          url: '/user_sessions/' + current_user_id, // This is a URL on your website.
          data: { _method: "delete" },
          success: function(res, status, xhr) { window.location.reload(); },
          error: function(res, status, xhr) { alert("logout failure" + res); }
        });
      }
    }
  };

  var signinLink = document.getElementById('signin');
  if (signinLink) {
    signinLink.onclick = function() { 
      if (mock_login) 
        watch_callbacks.onlogin("mock");
      else
        navigator.id.request(); 
      return false;
    };
  };
   
  var signoutLink = document.getElementById('signout');
  if (signoutLink) {
    signoutLink.onclick = function() { 
      if (mock_login) 
        watch_callbacks.onlogout();
      else
        navigator.id.logout(); 
      return false;
    };
  };
  
  navigator.id.watch(watch_callbacks);
});
