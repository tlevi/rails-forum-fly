// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import "jquery"
import "jquery_ujs"
import "popper"
import "bootstrap"

import "trix"
import "@rails/actiontext"

window.addEventListener("trix-file-accept", function(event) {
   event.preventDefault()
   alert("File attachment not supported!")
})

$(document).ready(function () {
  setTimeout(function () {
    setInterval(function () {
      $('.alert:first').alert('close');
    }, 2000);
  }, 3000);
});
