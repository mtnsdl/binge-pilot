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
    html = URI.open(url, "User-Agent" => USER_AGENT, "Accept-Language" => "en-US,en;q=0.9")
    doc = Nokogiri::HTML.parse(html)

    streaming_options = {}

    ['Stream', 'Rent', 'Buy', 'Ads'].each do |option_type|
      option_section = doc.search("h3").find { |node| node.text.strip == option_type }
      next unless option_section

      links_container = option_section.xpath('./following-sibling::div').first
      next unless links_container

      links_with_titles_icons_and_prices = links_container.search(".ott_filter_best_price.ott_filter_hd a, .ott_filter_hd a").map do |a|
        icon = a.xpath('./img').first['src'].strip if a.xpath('./img').first
        price_info = a.xpath('./following-sibling::span').first
        price = price_info&.search('.price')&.text&.strip

        {
          link: a['href'].strip,
          title: a['title'].strip,
          icon: icon,
          price: price,
        }
      end.select { |link_info| link_info[:link].start_with?("https://click.justwatch.com/") }

      streaming_options[option_type.downcase.to_sym] = links_with_titles_icons_and_prices
    end

    streaming_options
  end



end
