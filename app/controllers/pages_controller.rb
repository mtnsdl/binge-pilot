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
    @bookmarks = current_user.bookmarks.where(status_like: 'liked')
  end

  def discarded_list
    @bookmarks = current_user.bookmarks.where(status_like: 'disliked')
  end
end
