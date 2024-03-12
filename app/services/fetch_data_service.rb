require 'net/http'
require 'uri'
require 'json'
require 'date'

class FetchDataService
  TMDB_BASE_URL = "https://api.themoviedb.org/3/discover".freeze

  def initialize(content_format, mood_name, genres_by_mood = nil)
    @content_format = content_format
    @mood_name = mood_name
    include_query_genres
    @monetization = "flatrate|free|ads|rent|buy"
  end

  def call
    puts "Fetching data..."
    response = fetch_data_from_tmdb
    parse_response(response)
  end

  def include_query_genres
    # Movie Genres
    happy_movie_genres = [35, 10751] # Comedy, Family
    dramatic_movie_genres = [18, 36] # Drama, History
    thrilling_movie_genres = [28, 53] # Action, Thriller

    # TV Show Genres
    happy_tv_genres = [35, 10751, 10762] # Comedy, Family, Kids
    dramatic_tv_genres = [18, 80] # Drama, Crime
    thrilling_tv_genres = [10759, 9648, 10765] # Action & Adventure, Mystery, Sci-Fi & Fantasy

    selected_genres = []

    if @content_format == 'movie'
      selected_genres = case @mood_name.downcase
                        when "happy"
                          happy_movie_genres
                        when "dramatic"
                          dramatic_movie_genres
                        when "thrilling"
                          thrilling_movie_genres
                        else
                          happy_movie_genres + dramatic_movie_genres + thrilling_movie_genres
                        end
    elsif @content_format == 'tv'
      selected_genres = case @mood_name.downcase
                        when "happy"
                          happy_tv_genres
                        when "dramatic"
                          dramatic_tv_genres
                        when "thrilling"
                          thrilling_tv_genres
                        else
                          happy_tv_genres + dramatic_tv_genres + thrilling_tv_genres
                        end
    end

    @selected_genres = selected_genres.sample(3).join("|")
  end

  private

  def fetch_data_from_tmdb
    uri = URI(build_url)
    response = Net::HTTP.get_response(uri)
    if response.is_a?(Net::HTTPSuccess)
      response.body
    else
      puts "Error fetching data: #{response.code} #{response.message}"
      nil
    end
  end

  def build_url
    base_url = @content_format == 'movie' ? "#{TMDB_BASE_URL}/movie" : "#{TMDB_BASE_URL}/tv"
    "#{base_url}?#{query_string}"
  end

  def query_string
    years_ago = Date.today.prev_year(10).strftime('%Y-%m-%d')
    date_param = @content_format == 'movie' ? 'primary_release_date.gte' : 'first_air_date.gte'

    params = {
      'include_adult' => false,
      'include_video' => true,
      'locale' => "DE",
      'region' => "de",
      'language' => "en-US",
      'page' => rand(50),
      'sort_by' => "vote_average.desc",
      'vote_count.gte' => 100,
      'vote_average.gte' => 6,
      'with_genres' => @selected_genres,
      'without_genres' => "16,14",
      'with_watch_monetization_types' => @monetization,
      date_param => years_ago,
      'with_original_language' => "en",
      'api_key' => ENV['TMDB_API_KEY']
    }
    URI.encode_www_form(params)
  end

  def parse_response(response)
    begin
      data = JSON.parse(response)
      results = data&.fetch("results", [])
      filtered_results = results.select do |result|
        # Check for the presence of 'original_title' (movies) or 'original_name' (TV shows) and use regex as needed
        title = result['original_title'] || result['original_name']
        title =~ /\A[\p{Latin}\p{Mark}\p{Punctuation}\p{Number}\s]+\z/
      end
      return filtered_results
    rescue JSON::ParserError
      puts "Failed to parse JSON response."
      []
    end
  end

end
