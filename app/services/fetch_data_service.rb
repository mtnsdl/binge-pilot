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
    @monetization = "flatrate|free|ads|rent|buy"
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

    excluded_moods = case @mood&.name
                    when "Happy"
                      ["Thrilling", "Dramatic"]
                    when "Thrilling"
                      ["Happy", "Dramatic"]
                    when "Dramatic"
                      ["Happy", "Thrilling"]
                    else
                      []
                    end

    if @mood
      @excluded_genres = Genre.joins(:mood)
                              .where(genre_format: @content_format)
                              .where(moods: { name: excluded_moods })
                              .pluck(:genre_identifier).join("|")
    else
      @excluded_genres = ""
    end
  end



private

  def fetch_data_from_tmdb
    uri = URI(build_url)
    Net::HTTP.get(uri)
    raise
  end

  def build_url
    "#{TMDB_BASE_URL}/#{@content_format}?#{query_string}"
  end

  def query_string
    params = {
      include_adult: true,
      include_video: true,
      locale: "DE",
      region: "de",
      language: "en-US|de-DE",
      page: rand(50),
      sort_by: "popularity.desc",
      with_genres: @selected_genres,
      without_genres: @excluded_genres,
      with_watch_monetization_types: @monetization,
      api_key: ENV['TMDB_API_KEY']
    }
    URI.encode_www_form(params)
  end

  def parse_response(response)
    data = JSON.parse(response)
    data["results"] unless data.nil? || data["results"].nil?
  end
end
