require_relative "../services/fetch_data_service.rb"
require_relative "../services/application_service.rb"

class BookmarksController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index, :trigger_fetch_service]

  def index
    @content_format = params[:content]
    @mood = params[:mood]&.downcase
    fetch_genres_by_mood(@mood)
    @random_result = trigger_fetch_service
  end

  def trigger_fetch_service
    fetched_instance = FetchDataService.new(@content_format)
    @all_movie_results = fetched_instance.call
    @all_movie_results.sample
      # if movie is selected, then create bookmark
      # else we want to just take the title and add it to disliked list
  end

  def create_bookmark

    result_params = params[:result]
    content = Content.find_by(content_identifier: result_params[:id])
    # content.title = result_params[:title]
    # content.release_date = result_params[:release_date]

    unless content
      # create Content and then Bookmark
      content = Content.create(name: result_params[:title], content_identifier: result_params[:id])
    end
    Bookmark.create(
      content: content,
      user_id: current_user.id,
      status_like: params[:liked]
    )
    # raise
  end

  def fetch_genres_by_mood(mood_name)
    mood = Mood.find_by('LOWER(name) = ?', mood_name) if mood_name.present?
    @genres_by_mood = mood ? mood.genres : [Genre.all.sample].compact
  end
end
