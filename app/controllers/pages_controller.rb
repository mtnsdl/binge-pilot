class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home, :contentchoice, :moods]

  def home
  end

  def contentchoice
  end

  def moods
    @is_movie = params[:movies] == "true"
  end
end
