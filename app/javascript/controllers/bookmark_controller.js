import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['name', 'user', 'picture', 'id']

  connect() {
    const buttons = this.element.querySelectorAll('.button-streaming');
    buttons.forEach(button => {
      // Ensuring compatibility with iOS by setting an empty onclick attribute
      button.setAttribute('onclick', '');

      button.addEventListener('pointerdown', () => {
        button.disabled = true;
      });
    });
  }

  createBookmarkAndRedirect(event){
    event.preventDefault();
    const url = event.currentTarget.getAttribute('href'); // Ensure you're getting the correct URL
    const csrfToken = document.querySelector("meta[name='csrf-token']").content;

    fetch(`/bookmarks/create_watched_bookmark`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": csrfToken
      },
      body: JSON.stringify({
        result_title: this.nameTarget.value,
        result_picture: this.pictureTarget.value,
        user: this.userTarget.value,
        result_id: this.idTarget.value
      })
    })
    .then(response => {
      if(response.ok) {
        // Use window.location for navigation to ensure compatibility across browsers, including iOS
        window.location.href = url;
      } else {
        console.error('Failed to create bookmark');
        // Optionally handle the error, re-enable the button, or provide user feedback
      }
    })
    .catch(error => {
      console.error('Error:', error);
      // Handle any errors that occurred during fetch
    });
  }

