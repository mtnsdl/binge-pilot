require "open-uri"
require "nokogiri"

class FetchMovieProviderService
  USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36"

  def initialize(content, id, name, random_result_name_parse)
    @content = content
    @id = id
    @name = name
    @random_result_name_parse = random_result_name_parse
  end

  def fetch_movie_urls
    url = "https://www.themoviedb.org/#{@content}/#{@id}-#{@random_result_name_parse}/watch?locale=DE"
    puts url
    html = URI.open(url, "User-Agent" => USER_AGENT, "Accept-Language" => "en-US,en;q=0.9")
    doc = Nokogiri::HTML.parse(html)

    stream_text = doc.search('h3').find { |node| node.text.strip == "Stream" }.try(:text).try(:strip)
    rent_text = doc.search('h3').find { |node| node.text.strip == "Rent" }.try(:text).try(:strip)
    buy_text = doc.search('h3').find { |node| node.text.strip == "Buy" }.try(:text).try(:strip)
    ads_text = doc.search('h3').find { |node| node.text.strip == "Ads" }.try(:text).try(:strip)


    # stream_links = doc.search('.ott_filter_best_price ott_filter_hd a').map { |link| link['href'].strip }
    # image_links = doc.search('.ott_filter_best_price ott_filter_hd img').map { |img| img['src'].strip }

    { stream_text: stream_text, rent_text: rent_text, buy_text: buy_text, ads_text: ads_text }
  end
end
