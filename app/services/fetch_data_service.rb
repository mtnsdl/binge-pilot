require "net/http"
require "uri"
require "json"

class FetchDataService
  TMDB_BASE_URL = "https://api.themoviedb.org/3/discover".freeze

  def initialize(content_format, mood_name, genres_by_mood)
    @content_format = content_format
    @mood_name = mood_name
    @genres_by_mood = genres_by_mood
    include_query_genres
  end

  def call
    puts "Fetching data..."
    response = fetch_data_from_tmdb
    random_result = parse_response(response)
    random_result
  end

  private

  def include_query_genres
    @selected_genres = @genres_by_mood.pluck(:genre_identifier).join("|")
  end


  def exclude_query_genres
    
  end
    #     if
  #     @test = Genre.where(mood_id: ).pluck(:genre_identifier).join("|")
  #     elsif
  #     else
  #   end



  def fetch_data_from_tmdb
    uri = URI(build_url)
    Net::HTTP.get(uri)
  end

  def build_url
    "#{TMDB_BASE_URL}/#{@content_format}?#{query_string}"
  end

  def query_string
    params = {
      include_adult: false,
      include_video: false,
      language: "en-US",
      page: 1,
      sort_by: "popularity.desc",
      with_genres: @selected_genres,
      api_key: ENV['TMDB_API_KEY'] # Include your API key
    }

    URI.encode_www_form(params)
    raise
  end

  def parse_response(response)
    data = JSON.parse(response)
    data["results"] unless data.nil? || data["results"].nil?
  end
end
