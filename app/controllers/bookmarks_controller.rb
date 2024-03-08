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
      status_like: params[:liked] == 'true' ? 'liked' : 'disliked'
    )
    redirect_to bookmarks_path(mood: params[:mood], content: params[:content]), notice: "Bookmark was created 🎉"
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
  end

  def reject_offered_content(all_content_results)
    offered_content_ids = []
    current_user.bookmarks.where(offered: true).each do |bookmark|
      offered_content_ids << bookmark.content.content_identifier
    end
  end

  def fetch_genres_by_mood
    if @mood_name
      mood = Mood.find_by('LOWER(name) = ?', @mood_name) if @mood_name.present?
      @genres_by_mood = mood.genres.where(genre_format: @content_format)
    else
      @genres_by_mood = [Genre.where(genre_format: @content_format).sample]
    end
  end
end
