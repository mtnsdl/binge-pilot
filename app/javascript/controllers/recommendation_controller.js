import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["image", "movieGenre", "tvShowGenre"]

  connect() {
    console.log("hello from reccomendation controller")
    }

    selectMovies(event) {
      event.preventDefault();
      this.hideInitialOptions();
      this.movieGenreTargets.forEach((element) => element.classList.remove("hidden"));
    }

    selectTVShows(event) {
      event.preventDefault();
      this.hideInitialOptions();
      this.tvShowGenreTargets.forEach((element) => element.classList.remove("hidden"));
    }

    hideInitialOptions() {
      this.imageTargets.forEach((element) => element.classList.add("hidden"));
    }

  loadMovies() {
    const apiKey = ENV['TMDB_API_KEY']
    const baseUrl = "https://api.themoviedb.org/3/discover/movie";
    const queryParams = "include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc";
    const url = `${baseUrl}?api_key=${apiKey}&${queryParams}`;

    fetch(url)
      .then(response => {
        if (!response.ok) {
          throw new Error("Network response for movies was not ok");
        }
        return response.json();
      })
      .then(data => {
        console.log(data);
      })
      .catch(error => console.error("There was a problem with the fetch operation in movies: ", error));
  }

  loadTVShows() {
    const apiKey = ENV['TMDB_API_KEY']
    const baseUrl = "https://api.themoviedb.org/3/discover/tv";
    const queryParams = "include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc";
    const url = `${baseUrl}?api_key=${apiKey}&${queryParams}`;

    fetch(url)
      .then(response => {
        if (!response.ok) {
          throw new Error("Network response for tv shows was not ok");
        }
        return response.json();
      })
      .then(data => {
        console.log(data);
      })
      .catch(error => console.error("There was a problem with the fetch operation in tv shows: ", error));
  }
}
