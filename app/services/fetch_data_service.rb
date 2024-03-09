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
    fetch_genres_excluding_moods
  end

  def call
    puts "Fetching data..."
    response = fetch_data_from_tmdb
    random_result = parse_response(response)
    random_result
  end

  def include_query_genres
    @selected_genres = @genres_by_mood.pluck(:genre_identifier).join("|")
  end


  def fetch_genres_excluding_moods
    @mood = Mood.find_by('LOWER(name) = ?', @mood_name.downcase) if @mood_name.present?

    excluded_genres_happy = ["thrilling", "dramatic"]
    excluded_genres_dramatic = ["happy", "thrilling"]
    excluded_genres_thrilling = ["happy", "dramatic"]

    if @mood
      case @mood.name
      when "Happy"
        @excluded_genres = Genre.joins(:mood)
                                .where(genre_format: @content_format)
                                .where.not(moods: { name: excluded_genres_happy })
                                .pluck(:genre_identifier).join(",")
      when "Thrilling"
        @excluded_genres = Genre.joins(:mood)
                                .where(genre_format: @content_format)
                                .where.not(moods: { name: excluded_genres_thrilling })
                                .pluck(:genre_identifier).join(",")
      when "Dramatic"
        @excluded_genres = Genre.joins(:mood)
                                .where(genre_format: @content_format)
                                .where.not(moods: { name: excluded_genres_dramatic })
                                .pluck(:genre_identifier).join(",")
      end
    else
      @excluded_genres = ""
    end
  end


private

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
 #     without_genres: @excluded_genres,
      api_key: ENV['TMDB_API_KEY']
    }
    URI.encode_www_form(params)
  end

  def parse_response(response)
    data = JSON.parse(response)
    data["results"] unless data.nil? || data["results"].nil?
  end
end
