// Import and register all your controllers from the importmap under controllers/*

import { application } from "controllers/application"

// Eager load all controllers defined in the import map under controllers/**/*_controller
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

// Lazy load controllers as they appear in the DOM (remember not to preload controllers in import map!)
// import { lazyLoadControllersFrom } from "@hotwired/stimulus-loading"
// lazyLoadControllersFrom("controllers", application)

// document.addEventListener('DOMContentLoaded', function() {
//   var container = document.querySelector('.poster-container');

//   function toggleFlip() {
//       container.classList.toggle('flip');

//       var icon = document.querySelector('.flip-icon'); // Selects the flip icon within the container

//       if (container.classList.contains('flip')) {
//           icon.src = icon.dataset.flipIconReverse;
//       } else {
//           icon.src = icon.dataset.flipIconInfo;
//       }
//   }

//   // Listening for both click and touchend events
//   container.addEventListener('click', toggleFlip);
//   container.addEventListener('touchend', function(e) {
//       e.preventDefault(); // Prevents the click event from firing after touchend
//       toggleFlip();
//   });
// });
