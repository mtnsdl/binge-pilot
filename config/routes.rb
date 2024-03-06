Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  get "/contentchoice", to: "pages#contentchoice", as: :contentchoice
  get "/moods", to: "pages#moods", as: :moods
  get "/bookmarks", to: "bookmarks#index", as: :bookmarks
  get "/bookmarks/fetchapi", to:"bookmarks#fetch_data"

  get "/profile", to: "pages#profile"
  get "/profile/liked_list", to: "pages#liked_list"
  get "/profile/discarded_list", to: "pages#discarded_list"
  get "/profile/watched_list", to: "pages#watched_list"

#  get "/moviescard", to: "pages#moviescard", as: :moviescard
# post '/recommendations', to: 'pages#recommendations'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"


end
