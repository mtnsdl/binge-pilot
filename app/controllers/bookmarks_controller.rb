class BookmarksController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index]


  def index
    @is_movie = params[:movies] == 'true'
    @mood = params[:mood]

    @genreId = 28
  end

end
