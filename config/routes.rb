Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"


  get "/contentchoice", to: "pages#contentchoice", as: :contentchoice
  get "/moods", to: "pages#moods", as: :moods
  get "/bookmarks", to: "bookmarks#index", as: :bookmarks
  get "/bookmarks/fetchapi", to:"bookmarks#trigger_fetch_service"
  get "/bookmarks/fetchstreaming", to:"bookmarks#fetch_streaming_links"
  get "/bookmarks/:id/checkout", to: "bookmarks#checkout", as: :bookmarks_checkout

  get "/profile", to: "pages#profile"
  get "/profile/liked_list", to: "pages#liked_list"
  get "/profile/discarded_list", to: "pages#discarded_list"
  get "/profile/watched_list", to: "pages#watched_list"

  get "/bookmarks/:id/change_status_like", to: "bookmarks#change_status_like", as: :change_status_like
  get "/bookmarks/:id/change_status_watch", to: "bookmarks#change_status_watch", as: :change_status_watch


  post 'bookmarks/create', to: 'bookmarks#create_bookmark', as: :create_bookmark
  post 'bookmarks/create_watched_bookmark', to: 'bookmarks#create_watched_bookmark', as: :create_watched_bookmark
  post 'bookmarks/create_bookmark_save_for_later', to: 'bookmarks#save_when_no_provider', as: :create_bookmark_save_for_later

  delete '/liked_list/:id', to: 'pages#destroy', as: 'remove_from_list'
  get '/bookmarks/:id/checkout', to: 'pages#checkout', as: 'go_to_checkout'

#  get "/moviescard", to: "pages#moviescard", as: :moviescard
# post '/recommendations', to: 'pages#recommendations'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"


end
