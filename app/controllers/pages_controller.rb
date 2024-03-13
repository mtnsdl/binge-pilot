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
    all_bookmarks_liked = current_user.bookmarks.where(status_like: 'liked')
    bookmarks_liked_unique = all_bookmarks_liked.uniq { |bookmark| bookmark.content.id }
    bookmarks = bookmarks_liked_unique.reject { |bookmark| bookmark.status_watch == 'watched' }
    @bookmarks_liked = bookmarks
  end

  def discarded_list
    # @bookmarks_disliked = current_user.bookmarks.where(status_like: 'disliked')
    all_bookmarks_disliked = current_user.bookmarks.where(status_like: 'disliked')
    bookmarks_disliked_unique = all_bookmarks_disliked.uniq { |bookmark| bookmark.content.id }
    bookmarks = bookmarks_disliked_unique.reject { |bookmark| bookmark.status_watch == 'watched' }
    @bookmarks_disliked = bookmarks
  end

  def watched_list
    @bookmarks_watched = current_user.bookmarks.where(status_watch: 'watched')
  end

  def destroy
    bookmark = Bookmark.find(params[:id])
    name = bookmark.content.name
    bookmark.destroy

    if request.referer&.end_with?(profile_liked_list_path)
      redirect_to profile_liked_list_path
    elsif request.referer&.end_with?(profile_watched_list_path)
      redirect_to profile_watched_list_path
    else
      redirect_to profile_discarded_list_path
    end
  end
end
