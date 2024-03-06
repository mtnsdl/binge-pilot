class BookmarksController < ApplicationController
require "net/http"
require "json"
skip_before_action :authenticate_user!, only: [ :index, :fetch_data]

  def index
    @is_movie = params[:movies] == 'true'
    @mood = params[:mood]
    @random_movie = fetch_data
  end

  def fetch_data
    puts "Fetching data..."
    api_key = ENV["TMDB_API_KEY"]
    base_url = "https://api.themoviedb.org/3/discover/movie"
    query_params = "include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc"
    url = "#{base_url}?api_key=#{api_key}&#{query_params}"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)
    @random_movie = data["results"].sample
  end

end
