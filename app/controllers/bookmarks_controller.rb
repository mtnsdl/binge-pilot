class BookmarksController < ApplicationController
  require "net/http"
  require "json"
  skip_before_action :authenticate_user!, only: [ :index, :fetch_data]

  def index
    @is_movie = params[:movies] == 'true'
    @mood = params[:mood]
    @random_result = fetch_data
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
    unless data.nil?
      @all_results = data["results"]
      @random_result = @all_results.sample
    # else
      # @random_movie = fake movie
    end
  end

  def create_bookmark

    result_params = params[:result]
    content = Content.find_by(content_identifier: result_params[:id])
    # content.title = result_params[:title]
    # content.release_date = result_params[:release_date]

    unless content
      # create Content and then Bookmark
      content = Content.create(name: result_params[:title], content_identifier: result_params[:id])
    end
    Bookmark.create(
      content: content,
      user_id: current_user.id,
      status_like: params[:liked]
    )
    # raise
  end
end
