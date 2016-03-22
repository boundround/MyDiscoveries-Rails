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

require 'api_constraints'
require 'routes/constraints/subcategories'

Rails.application.routes.draw do

  mount API::Base => '/'
  mount GrapeSwaggerRails::Engine => '/apidoc'

  resources :bug_posts
  get '/bugs' => 'bug_posts#new'
  get 'all_bugs' => 'bug_posts#index'

  mount Ckeditor::Engine => '/ckeditor'
  post '/rate' => 'rater#create', :as => 'rate'
  constraints(SSConstraint.new) do
    get '/', to: 'places#programsearch', as: nil
  end

  constraints(BRConstraint.new) do
    get '/', to: 'pages#index', as: :root
  end

  get 'puzzles/index'

  get 'pages/terms' => 'pages#terms'
  get 'pages/privacy' => 'pages#privacy'
  get '/robots.txt' => 'pages#robots'

  resources :search_suggestions

  resources :transactions

  require 'sidekiq/web'

  mount Sidekiq::Web => '/sidekiq'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  mount Bootsy::Engine => '/bootsy', as: 'bootsy'

  mount Soulmate::Server, :at => "/sm"

  get 'factual_places/search' => 'factual_places#search'

  post 'search_suggestions' => 'search_suggestions#index'

  post 'searchqueries/create' => 'search_queries#create'
  post 'pages/want_notification' => 'pages#want_notification'
  get "areas/mapdata" => "areas#mapdata"
  get "areas/search" => "areas#search"
  get "places/mapdata" => "places#mapdata"
  get "places/placeareasmapdata" => "places#placeareasmapdata"
  get "places/search" => "places#search"
  get "places/liked_places" => "places#liked_places"
  get "places/tags" => "places#tags"
  get "programs/tags" => "programs#tags"

  get "places/publishing_queue" => "places#publishing_queue"

  get "places/debug" => 'places#debug'
  get "places/programsearch" => 'places#programsearch' #xyrin index.html
  get "places/placeprograms" => 'places#placeprograms' #xyrin result.html
  get "places/programsearchresultslist" => 'places#programsearchresultslist' #xyrin search.html
  get "places/programsearchresultsmap" => 'places#programsearchresultsmap' #xyrin map.html

  get "/sitemap" => redirect("https://s3-ap-southeast-2.amazonaws.com/brwebproduction/sitemaps/sitemap.xml.gz")

  post 'fun_facts_users/create' => 'fun_facts_users#create'
  post 'fun_facts_users/destroy' => 'fun_facts_users#destroy'
  post 'photos_users/create' => 'photos_users#create'
  post 'photos_users/destroy' => 'photos_users#destroy'
  post 'places_users/create' => 'places_users#create'
  post 'places_users/destroy' => 'places_users#destroy'
  post 'games_users/create' => 'games_users#create'
  post 'games_users/destroy' => 'games_users#destroy'
  post 'videos_users/create' => 'videos_users#create'
  post 'videos_users/destroy' => 'videos_users#destroy'
  post 'user_photos_users/create' => 'user_photos_users#create'
  post 'user_photos_users/destroy' => 'user_photos_users#destroy'
  post 'stories_users/create' => 'stories_users#create'
  post 'stories_users/destroy' => 'stories_users#destroy'
  post 'reviews_users/create' => 'reviews_users#create'
  post 'reviews_users/destroy' => 'reviews_users#destroy'

  resources :user_photos
  post 'user_photos/profile_create' => 'user_photos#profile_create'

  resources :stories
  post 'stories/profile_create' => 'stories#profile_create'

  devise_scope :user do
    get "/sign_in" => "devise/sessions#new"
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  devise_for :users, :controllers => { :registrations => "registrations", :omniauth_callbacks => "users/omniauth_callbacks", :sessions => "sessions" }

  resources :pages

  get '/google_map_home' => 'pages#google_map_home'

  get '/puzzles/:action' => 'puzzles#:action'

  get '/users/games' => 'users#games'
  get '/users/videos' => 'users#videos'
  get '/users/places' => 'users#places'
  get '/users/fun_facts' => 'users#fun_facts'
  get '/users/instagram_feed' => 'users#instagram_feed'
  get '/users/draft_content' => 'users#draft_content' # All User Uploaded Content in Draft
  resources :users do
    collection { get 'leaderboard' }
    member { get 'favourites' }
    member { get 'photos' }
    member { get 'reviews' }
    member { get 'stories' }
  end

  post '/places/transfer_assets' => 'places#transfer_assets'
  get '/places/:id/new_edit' => 'places#new_edit'
  get '/places/:id/refresh_blog' => 'places#refresh_blog'
  # get '/places/:id/hero_image_picker' => 'places#hero_image_picker'
  resources :places do
    member { get 'preview' }
    member { get 'hero_image_picker'}
    collection { get 'all_edited'} # all place content in draft
    collection { get 'user_created'} # all place content in draft
    collection { get 'merge'}
    resources :photos
    resources :videos
    resources :discounts
    resources :fun_facts
    resources :games
    resources :reviews
    resources :stories
    resources :user_photos
    resources :three_d_videos
    resources :similar_places
    resources :good_to_knows
    collection { post :import }
  end

  resources :three_d_videos

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
    resources :good_to_knows
    collection { post :import }
  end

  resources :points_values

  match '/send_postcard', to: 'places#send_postcard', via: 'post'

  match '/send_user_story', to: 'users#send_story', via: 'post'

  match 'content_rejected', to: 'places#content_rejected', via: 'post'

  get '/virginaustralia', to: 'places#show', :defaults => {:id => 939}

  get "/users/username/new" => "users/accounts#forgot_username"
  post "/users/username/send_username" => "users/accounts#send_username"

  get "/wp-blog/:id/:place", to: "places#wp_blog"
  # get "/wp-blog-cat/:id", to: "primary_categories#wp_blog"


  get "/primary_categories/cms_index", to: "primary_categories#cms_index"
  get "/subcategories/cms_index", to: "subcategories#cms_index"
  get "categories", to: "categories#index"

  resources :primary_categories

  resources :subcategories do
    collection do
      get 'specific/:age_ranges', action: 'specific', as: :specific, constraints: Routes::Constraints::Subcategories.new
    end
  end

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

  match '/:corppath', to: redirect("http://corporate.boundround.com/%{corppath}"), via: [:get, :post]
end
