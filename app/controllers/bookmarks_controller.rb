require_relative "../services/fetch_data_service.rb"
require_relative "../services/fetch_providers.rb"

class BookmarksController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index]
  before_action :set_content_format_and_mood, only: :index
  before_action :fetch_genres_by_mood, only: :index
  before_action :trigger_fetch_service, only: :index

def index
  # Example API call, adjust based on your actual implementation
  service = FetchDataService.new(params[:content], params[:mood])
  response = service.call

  if response.present? && response.any?
    @random_result = response.first
    @random_result_title = @random_result["original_title"] || @random_result["original_name"] || "Title not available"
    @random_result_name = @random_result["title"] || @random_result["name"] || "Name not available"
    @random_result_id = @random_result["id"]
  else
    redirect_to fallback_path, alert: "Data not available for the selected content and mood." and return
  end
end

  def create_bookmark
    return unless check_if_bookmark_is_in_db

    content = Content.find_or_create_by(content_identifier: params[:result_id].to_i) do |c|
      c.name = params[:result_title]
      c.picture_url = params[:result_picture]
      c.medium = params[:content]
    end

    Bookmark.create(
      content:,
      user: current_user,
      offered: true,
      status_like: params[:liked] == 'true' ? 'liked' : 'disliked',
      status_watch: params[:watched] == 'true' ? 'watched' : 'not_watched'
    )
    p params
    redirect_to bookmarks_path(mood: params[:mood], content: params[:content]), notice: "Bookmark was created 🎉"
  end

  def change_status_like
    bookmark = Bookmark.find(params[:id])
    if bookmark.status_like == "liked"
      bookmark.status_like = "disliked"
    else
      bookmark.status_like = "liked"
    end
    bookmark.save

    if request.referer&.end_with?(profile_liked_list_path)
      redirect_to profile_liked_list_path
    else
      redirect_to profile_discarded_list_path
    end
  end

  def change_status_watch
    bookmark = Bookmark.find(params[:id])
    bookmark.status_like = "disliked"
    bookmark.status_watch = "not_watched"
    bookmark.save

    redirect_to profile_watched_list_path
  end

  def create_watched_bookmark
    return unless check_if_bookmark_is_in_db

    content = Content.find_or_create_by(content_identifier: params[:result_id].to_i) do |c|
      c.name = params[:result_title]
      c.picture_url = params[:result_picture]
    end

    Bookmark.create!(
      content: content,
      user_id: params[:user].to_i,
      offered: true,
      status_watch: 'watched'
    )
  end

  def checkout
    @content = params[:content] || bookmark.content.medium
    @id = params[:id] || bookmark.content.content_identifier
    @name = params[:name] || params[:result_title]
    @random_result_name_parse = @name.gsub(" ", "-").gsub("'", "-").gsub(":", "")

    fetched_providers = FetchProviders.new(@content, @id, @name, @random_result_name_parse)
    @all_streaming_providers = fetched_providers.fetch_movie_urls
  end

  def save_when_no_provider
    content = Content.find_or_create_by(content_identifier: params[:id].to_i) do |c|
      c.name = params[:result_title]
      c.picture_url = params[:result_picture]
    end

    Bookmark.create(
      content: content,
      user: current_user,
      offered: true,
      status_like: 'liked',
      status_watch: 'not_watched'
    )
    redirect_to bookmarks_path(mood: params[:mood], content: params[:content]), notice: "Bookmark was created 🎉"
  end

  private

  def set_content_format_and_mood
    @content_format = params[:content]
    @mood_name = params[:mood]&.downcase
  end

  def check_if_bookmark_is_in_db
    content_id = params[:result_id].to_i

    existing_bookmark = current_user.bookmarks.find_by(content_id: content_id)
    if existing_bookmark.present?
      false
    end
    true
  end

  def trigger_fetch_service
    fetched_instance = FetchDataService.new(@content_format, @mood_name, @genres_by_mood)
    @all_content_results = fetched_instance.call
    @new_offers = reject_offered_content(@all_content_results)
    @random_result = @new_offers&.sample
  end

  def reject_offered_content(all_content_results)
    offered_content_identifiers = []

    current_user.bookmarks.where(offered: true).each do |offered_bookmark|
      offered_content_identifiers << offered_bookmark.content.content_identifier
    end

    all_content_results.map! { |result| result["id"] }
    # Right now we are only checking for doublicated IDs
    # TODO Check also for douplicated titles, etc. for better result
    unique_content_result_ids = all_content_results.uniq
    unique_offered_content_identifiers = offered_content_identifiers.uniq

    unique_content_result_ids&.reject { |result| unique_offered_content_identifiers.include?(result) }
  end

  def fetch_genres_by_mood
    if @mood_name.present?
      mood = Mood.find_by('LOWER(name) = ?', @mood_name.downcase)
      if mood
        @genres_by_mood = mood.genres.where(genre_format: @content_format)
      else
        @genres_by_mood = [Genre.where(genre_format: @content_format).sample]
      end
    else
      @genres_by_mood = [Genre.where(genre_format: @content_format).sample]
    end
  end

  def fetch_streaming_links
    fetched_providers = FetchProviders.new(@content, @id, @name, @random_result_name_parse)
    @all_streaming_providers = fetched_providers.fetch_movie_urls
  end
end
