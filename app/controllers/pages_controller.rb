class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home, :contentchoice, :moods]

  def home
  end

  def profile
    @user = current_user
    # IN THE VIEW DO:
    # @user.name
    # @user.movies
  end

  def contentchoice
    @user = current_user
  end


  def moods
    @is_movie = params[:movies] == "true"
  end

  def liked_list
    @bookmarks_liked = current_user.bookmarks.where(status_like: 'liked')
  end

  def discarded_list
    @bookmarks_disliked = current_user.bookmarks.where(status_like: 'disliked')
  end

  def destroy
    bookmark = Bookmark.find(params[:id])
    name = bookmark.content.name
    bookmark.destroy
    if bookmark.status_like == 'liked'
      redirect_to profile_liked_list_path, notice: "#{name} was removed from your list"
    else
      redirect_to profile_discarded_list_path, notice: "#{name} was removed from your list"
    end
  end
end



# def destroy
#   @cloud.destroy
#   redirect_to clouds_path, notice: 'Cloud was successfully destroyed.'
# end
