class SSConstraint
  def matches?(request)
    request.host().include?("schoolsafari") || request.host().include?("crzy")
  end
end

class BRConstraint
  def matches?(request)
    !request.host().include?("schoolsafari") && !request.host().include?("crzy")
  end
end

Rails.application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'
  post '/rate' => 'rater#create', :as => 'rate'
  constraints(SSConstraint.new) do
    get '/', to: 'places#programsearch', as: nil
  end

  constraints(BRConstraint.new) do
    get '/', to: 'pages#globe', as: :root
  end

  get 'puzzles/index'

  resources :search_suggestions

  require 'sidekiq/web'

  mount Sidekiq::Web => '/sidekiq'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  mount Bootsy::Engine => '/bootsy', as: 'bootsy'

  mount Soulmate::Server, :at => "/sm"

  get 'factual_places/search' => 'factual_places#search'

  post 'search_suggestions' => 'search_suggestions#index'

  post 'searchqueries/create' => 'search_queries#create'
  post 'notification' => 'pages#want_notification'
  get "areas/mapdata" => "areas#mapdata"
  get "areas/search" => "areas#search"
  get "places/mapdata" => "places#mapdata"
  get "places/search" => "places#search"
  get "places/liked_places" => "places#liked_places"
  get "places/tags" => "places#tags"
  get "programs/tags" => "programs#tags"
  
  post "places/user_create" => "places#user_create"

  get "places/publishing_queue" => "places#publishing_queue"

  get "places/debug" => 'places#debug'
  get "places/programsearch" => 'places#programsearch' #xyrin index.html
  get "places/placeprograms" => 'places#placeprograms' #xyrin result.html
  get "places/programsearchresultslist" => 'places#programsearchresultslist' #xyrin search.html
  get "places/programsearchresultsmap" => 'places#programsearchresultsmap' #xyrin map.html

  get "/sitemap" => redirect("https://s3-ap-southeast-2.amazonaws.com/brwebproduction/sitemaps/sitemap.xml.gz")

  post 'fun_facts_users/create' => 'fun_facts_users#create'
  post 'fun_facts_users/destroy' => 'fun_facts_users#destroy'
  post 'areas_users/create' => 'areas_users#create'
  post 'areas_users/destroy' => 'areas_users#destroy'
  post 'photos_users/create' => 'photos_users#create'
  post 'photos_users/destroy' => 'photos_users#destroy'
  post 'places_users/create' => 'places_users#create'
  post 'places_users/destroy' => 'places_users#destroy'
  post 'games_users/create' => 'games_users#create'
  post 'games_users/destroy' => 'games_users#destroy'
  post 'videos_users/create' => 'videos_users#create'
  post 'videos_users/destroy' => 'videos_users#destroy'

  resources :user_photos

  resources :areas do
    resources :photos
    resources :videos
    resources :games
    resources :fun_facts
    resources :discounts
    resources :reviews
    resources :stories
    resources :user_photos
    collection { post :import }
  end

  devise_scope :user do
    get "/sign_in" => "devise/sessions#new"
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  devise_for :users, :controllers => { :registrations => "registrations", :omniauth_callbacks => "users/omniauth_callbacks", :sessions => "sessions" }

  resources :pages

#  root :to => 'pages#globe'

  get '/map' => 'pages#index'

  get '/map_only' => 'pages#map_only'
  
  get '/google_map_home' => 'pages#google_map_home'

  get '/puzzles/:action' => 'puzzles#:action'

  get '/users/photos' => 'users#photos'
  get '/users/games' => 'users#games'
  get '/users/videos' => 'users#videos'
  get '/users/places' => 'users#places'
  get '/users/fun_facts' => 'users#fun_facts'
  get '/users/stories' => 'users#stories'
  get '/users/draft_content' => 'users#draft_content' # All User Uploaded Content in Draft
  resources :users


  resources :places do
    member { get 'preview' }
    collection { get 'all_edited'} # all place content in draft
    resources :photos
    resources :videos
    resources :discounts
    resources :fun_facts
    resources :games
    resources :reviews
    resources :stories
    resources :user_photos
    collection { post :import }
  end

  resources :photos do
    collection { post :import }
  end

  resources :videos do
    collection { post :import }
  end

  resources :games do
    collection { post :import }
  end

  resources :programs do
    resources :webresources
    collection { post :import }
    collection { post :validate_import }
  end

  resources :discounts

  resources :fun_facts do
    collection { post :import }
  end

  resources :countries do
    resources :videos
    resources :photos
    resources :fun_facts
    resources :famous_faces
    resources :info_bits
    collection { post :import }
  end

  match '/send_postcard', to: 'places#send_postcard', via: 'post'

  match '/send_user_story', to: 'users#send_story', via: 'post'

  match 'content_rejected', to: 'places#content_rejected', via: 'post'

  get '/virginaustralia', to: 'places#show', :defaults => {:id => 939}

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
