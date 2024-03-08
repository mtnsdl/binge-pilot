require_relative "../services/fetch_data_service.rb"

class BookmarksController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :trigger_fetch_service]

  def index
    @content_format = params[:content]
    @mood_name = params[:mood]&.downcase
    fetch_genres_by_mood(@mood_name, @content_format)
    @random_result = trigger_fetch_service
    if @random_result
      @random_result_title = @random_result["original_title"] || @random_result["original_name"]
    end
  end

  def trigger_fetch_service
    fetched_instance = FetchDataService.new(@content_format, @mood_name, @genres_by_mood)
    @all_content_results = fetched_instance.call

    disliked_content_ids = []
    current_user.bookmarks.where(status_like: 'disliked').each do |bookmark|
      disliked_content_ids << bookmark.content.content_identifier
    end

    # If either of these is nil then the movies/shows are unwatched
    #  t.string "status_like"
    # t.string "status_watch"

    # Rejecting all Disliked Movies from the current results
    @all_content_results.reject! { |content| disliked_content_ids.include?(content['id']) }
    # Double-checking that there are no dublicates on ids
    # @all_content_results.uniq! { |content| content['id'] }

    @random_result = @all_content_results&.sample
  end

  def create_bookmark
    p params
    result_id = params[:result_id].to_i
    result_title = params[:result_title]
    result_picture = params[:result_picture]
    liked = params[:liked] == 'true'

    content = Content.find_or_create_by(content_identifier: result_id) do |c|
      c.name = result_title
      c.picture_url = result_picture
    end

    Bookmark.create(
      content: content,
      user: current_user,
      status_like: liked ? 'liked' : 'disliked'

    )
    redirect_to bookmarks_path(mood: params[:mood], content: params[:content]), notice: "Bookmark was successfully created."
  end

  def fetch_genres_by_mood(mood_name, content_format)
    mood = Mood.find_by('LOWER(name) = ?', mood_name) if mood_name.present?
        if mood
          @genres_by_mood = mood.genres.where(genre_format: content_format)
        else
          @genres_by_mood = [Genre.where(genre_format: content_format).sample]
    end
  end
end
