require_relative "../services/fetch_data_service.rb"

class BookmarksController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :trigger_fetch_service]

  def index
    p params
    @content_format = params[:content]
    @mood = params[:mood]&.downcase
    fetch_genres_by_mood(@mood)
    @random_result = trigger_fetch_service
  end

  def trigger_fetch_service
    fetched_instance = FetchDataService.new(@content_format)
    @all_movie_results = fetched_instance.call
    @random_result = @all_movie_results&.sample
  end

  def create_bookmark
    p params
    result_id = params[:result_id].to_i
    result_title = params[:result_title]
    liked = params[:liked] == 'true'

    content = Content.find_or_create_by(content_identifier: result_id) do |c|
      c.name = result_title
    end

    Bookmark.create(
      content: content,
      user: current_user,
      status_like: liked ? 'liked' : 'disliked',

    )
    redirect_to bookmarks_path(mood: params[:mood], content: params[:content]), notice: "Bookmark was successfully created."
  end

  private

  def fetch_genres_by_mood(mood_name)
    mood = Mood.find_by('LOWER(name) = ?', mood_name) if mood_name.present?
    @genres_by_mood = mood ? mood.genres : [Genre.all.sample].compact
  end
end
