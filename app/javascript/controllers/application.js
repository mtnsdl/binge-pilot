import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }

document.addEventListener('DOMContentLoaded', function() {
  var posterContainer = document.getElementById('swipeable-poster');
  var hammertime = new Hammer(posterContainer);

  hammertime.on('swipeleft', function(ev) {
    // Code to trigger when swiped left, setting :liked to false
    console.log("Swipe left detected");
    document.getElementById("discard").click(); // Simulate click on "discard" button
  });

  hammertime.on('swiperight', function(ev) {
    // Code to trigger when swiped right, setting :liked to true
    console.log("Swipe right detected");
    document.getElementById("save-for-later").click(); // Simulate click on "save for later" button
  });
});
