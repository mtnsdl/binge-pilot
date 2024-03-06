require_relative "../services/fetch_data_service.rb"
require_relative "../services/application_service.rb"

class BookmarksController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index, :trigger_fetch_service]

  def index
    @content_format = params[:content]
    @mood = params[:mood]
    @random_result = trigger_fetch_service
  end

  def trigger_fetch_service
    fetched_instance = FetchDataService.new(@content_format)
    fetched_instance.call_one
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
end
