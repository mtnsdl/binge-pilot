// Import and register all your controllers from the importmap under controllers/*

import { application } from "controllers/application"

// Eager load all controllers defined in the import map under controllers/**/*_controller
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

// Lazy load controllers as they appear in the DOM (remember not to preload controllers in import map!)
// import { lazyLoadControllersFrom } from "@hotwired/stimulus-loading"
// lazyLoadControllersFrom("controllers", application)

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
