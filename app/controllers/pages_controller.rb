class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
  end

  def profile
    @user = current_user
    # IN THE VIEW DO:
    # @user.name
    # @user.movies
  end
end
