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
    # Define subsets for each mood with refined genre selections
    happy_genres = [35, 10751] # Comedy, Family
    dramatic_genres = [18, 36] # Drama, History
    thrilling_genres = [28, 53] # Action, Thriller

    # Assuming 'mood' is a parameter that can be passed to this method or set before it's called
    selected_genres = case @mood_name.downcase
                      when "happy"
                        happy_genres
                      when "dramatic"
                        dramatic_genres
                      when "thrilling"
                        thrilling_genres
                      else
                        happy_genres + dramatic_genres + thrilling_genres
                      end

    # If there's feedback indicating certain genres consistently underperform or are less popular, exclude them dynamically
    # Example: Excluding 'Music' from happy genres if it's not resonating
    # This could be extended to use data for dynamic exclusions

    # Combine genres for the case of no specific mood, or if you want to give users a 'surprise me' option.
    # Randomize the selection if you want varied results each time the method is called
    @selected_genres = selected_genres.sample(3).join("|") # Randomly picks 3 genres from the selected list
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
    years_ago = Date.today.prev_year(10).strftime('%Y-%m-%d')

    params = {
      'include_adult' => false,
      'include_video' => true,
      'locale' => "DE",
      'region' => "de",
      'language' => "en-US", # API response language in English
      'page' => rand(50),
      'sort_by' => "vote_average.desc",
      'vote_count.gte' => 100, # Ensures statistical significance
      'vote_average.gte' => 6,
      'with_genres' => @selected_genres,
      'without_genres' => "16,14", # Excludes Animation and Fantasy genres
      'with_watch_monetization_types' => @monetization,
      'primary_release_date.gte' => years_ago,
      'with_original_language' => "en", # Only movies originally in English
      'api_key' => ENV['TMDB_API_KEY']
    }
    URI.encode_www_form(params)
  end

  def parse_response(response)
    data = JSON.parse(response)
    if data && data["results"]
      data["results"].select do |result|
        # This regex attempts to match titles that are more likely to contain primarily Latin characters,
        # including those with diacritics. It's more permissive and aims to include titles in languages
        # like French, Spanish, or German, which use Latin script with additional accents.
        result['title'] =~ /\A[\p{Latin}\p{Mark}\p{Punctuation}\p{Number}\s]+\z/
      end
    else
      []
    end
  end


end
