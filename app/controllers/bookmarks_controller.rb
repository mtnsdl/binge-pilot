require_relative "../services/fetch_data_service.rb"

class BookmarksController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index]
  before_action :set_content_format_and_mood, only: :index
  before_action :fetch_genres_by_mood, only: :index
  before_action :trigger_fetch_service, only: :index

  def index
    @random_result_title = @random_result["original_title"] || @random_result["original_name"]
  end

  def create_bookmark
    content = Content.find_or_create_by(content_identifier: params[:result_id].to_i) do |c|
      c.name = params[:result_title]
      c.picture_url = params[:result_picture]
    end
    Bookmark.create(
      content:,
      user: current_user,
      offered: true,
      status_like: params[:liked] == 'true' ? 'liked' : 'disliked',
      status_watch: params[:watched] == 'true' ? 'watched' : 'not_watched'
    )

    redirect_to bookmarks_path(mood: params[:mood], content: params[:content]), notice: "Bookmark was created 🎉"
  end

  def create_watched_bookmark
    content = Content.find_or_create_by(content_identifier: params[:result_id].to_i) do |c|
      c.name = params[:result_title]
      c.picture_url = params[:result_picture]
    end

    Bookmark.create!(
      content:,
      user_id: params[:user].to_i,
      offered: true,
      status_watch: 'true'
    )
  end

  def checkout
  end

  private

  def set_content_format_and_mood
    @content_format = params[:content]
    @mood_name = params[:mood]&.downcase
  end

  def trigger_fetch_service
    fetched_instance = FetchDataService.new(@content_format, @mood_name, @genres_by_mood)
    @all_content_results = fetched_instance.call
    @new_offers = reject_offered_content(@all_content_results)
    @random_result = @new_offers&.sample
      puts "@all_content_results: #{@all_content_results}"
      puts "@new_offers: #{@new_offers}"
      puts "@random_result: #{@random_result}"
  end

  def reject_offered_content(all_content_results)
    offered_content_ids = current_user.bookmarks&.where(offered: true).pluck(:content_id)
    all_content_results&.reject { |result| offered_content_ids.include?(result["id"].to_s) }
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
end
