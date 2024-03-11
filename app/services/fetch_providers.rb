require "open-uri"
require "nokogiri"

class FetchMovieProviderService
  USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36"

  def initialize(random_result_id, content_format, random_result_name_parse)
    @random_result_id = random_result_id
    @content_format = content_format
    @random_result_name_parse = random_result_name_parse
  end

  def fetch_movie_urls
    url = "https://www.themoviedb.org/#{@content_format}/#{@random_result_id}-#{@random_result_name_parse}/watch?locale=DE"
    html = URI.open(url, "User-Agent" => USER_AGENT)
    doc = Nokogiri::HTML.parse(html)

    stream_text = doc.search('h3').text.strip
    stream_links = doc.search('.ott_provider a').map { |link| link['href'].strip }
    image_links = doc.search('.ott_provider img').map { |img| img['src'].strip }

    { stream_text: stream_text, stream_links: stream_links, image_links: image_links }
  end
end
