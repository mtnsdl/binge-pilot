require 'net/http'
require 'uri'
require 'json'
require 'date'

class FetchDataService
  TMDB_BASE_URL = "https://api.themoviedb.org/3/discover".freeze

  def initialize(content_format, mood_name, genres_by_mood = nil)
    @content_format = content_format
    @mood_name = mood_name
    # Removed genres_by_mood from direct usage, as we'll hardcode a sample set for demonstration
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
    # Define subsets for each mood
    happy_genres = [35, 10751, 10402] # Comedy, Family, Music
    dramatic_genres = [18, 36, 10752] # Drama, History, War
    thrilling_genres = [28, 12, 53] # Action, Adventure, Thriller

    # Combine all genres for the random selection
    all_genres = happy_genres + dramatic_genres + thrilling_genres

    # Select genres based on the mood
    case @mood_name.downcase
    when "happy"
      @selected_genres = happy_genres.sample(3).join("|")
    when "dramatic"
      @selected_genres = dramatic_genres.sample(3).join("|")
    when "thrilling"
      @selected_genres = thrilling_genres.sample(3).join("|")
    else
      # If no specific mood is provided or recognized, select a random sample from all genres
      @selected_genres = all_genres.sample(3).join("|")
    end
  end

  def fetch_genres_excluding_moods
    # This method's implementation will depend on how you plan to use it.
    # For simplicity, this example will not modify it.
    # Implement your logic here if you plan to exclude certain genres based on moods.
    @excluded_genres = "" # Placeholder
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
    ten_years_ago = Date.today.prev_year(10).strftime('%Y-%m-%d')

    params = {
      'include_adult' => false,
      'include_video' => true,
      'locale' => "DE",
      'region' => "de",
      'language' => "de-DE",
      'page' => rand(50),
      'sort_by' => "popularity.desc",
      'with_genres' => @selected_genres,
      'without_genres' => @excluded_genres,
      'with_watch_monetization_types' => @monetization,
      'primary_release_date.gte' => ten_years_ago,
      'api_key' => ENV['TMDB_API_KEY']
    }
    URI.encode_www_form(params)
  end

  def parse_response(response)
    data = JSON.parse(response)
    data["results"] unless data.nil? || data["results"].nil?
  end
end
