require "net/http"
require  'URI'
require "json"

class FetchDataService
  TMDB_BASE_URL = "https://api.themoviedb.org/3/discover".freeze
  DEFAULT_QUERY_PARAMS = {
    include_adult: false,
    include_video: false,
    language: "en-US",
    page: 1,
    sort_by: "popularity.desc"
    # with_genres: @moods_array
  }.freeze

  def initialize(content_format)
    @content_format = content_format
    # @mood = mood
  end

  def call_one
    puts "Fetching data..."
    response = fetch_data_from_tmdb
    random_result = parse_response(response)
    random_result
  end

  def call_all
    puts "Fetching data..."
    response = fetch_data_from_tmdb
    random_result = parse_all_responses(response)
    random_result
  end


  # def mood_selection
  #   case feeling
  #   when feeling == 'happy'
  #     query = "36/36/38"
  #   when

  #   else

  #   end
  # end

  private

  def fetch_data_from_tmdb
    uri = URI(build_url)
    Net::HTTP.get(uri)
  end

  def build_url
    "#{TMDB_BASE_URL}/#{@content_format}?#{query_string}"
  end

  def query_string
    DEFAULT_QUERY_PARAMS.merge(api_key: ENV['TMDB_API_KEY']).map { |key, value| "#{key}=#{value}" }.join('&')
  end

  def parse_response(response)
    data = JSON.parse(response)
    data["results"].sample unless data.nil? || data["results"].nil?
  end

  def parse__all_responses(response)
    data = JSON.parse(response)
    data["results"] unless data.nil? || data["results"].nil? # || is part of forbidden forest
  end
end
