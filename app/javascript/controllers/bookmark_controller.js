import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['name', 'user', 'picture', 'id']

  connect() {
    const buttons = this.element.querySelectorAll('.button-streaming');
    buttons.forEach(button => {
      button.addEventListener('click', () => {
        button.disabled = true;
      });
    });
  }
createBookmarkAndRedirect(event){
  event.preventDefault()
  const csrfToken = document.querySelector("meta[name=csrf-token]").content

  fetch(`/bookmarks/create_watched_bookmark`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "X-CSRF-Token": csrfToken
    },
    body: JSON.stringify({
      result_title: this.nameTarget.value, result_picture: this.pictureTarget.value, user: this.userTarget.value, result_id: this.idTarget.value
    })
  })
    .then(response => {
      console.log(response)
      response.json()
    })
    .then(data => {
      console.log(data);
    })
    .catch(error => {
      console.error("Error:", error);
    });
  location.reload();
}
}
