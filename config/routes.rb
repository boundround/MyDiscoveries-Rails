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

  resources :competitions

  resources :posts do
    collection { get 'all_posts' }
    collection { get 'paginate' }
    member { get 'paginate_place_to_visit'}
    resources :places, controller: :places_posts
    resources :countries, controller: :countries_posts
    resources :subcategories, controller: :posts_subcategories
  end

  resources :stories do
    collection { get 'paginate' }
    member do
      get 'seo_analysis'
      get 'paginate_place'
      post :upload_image
      post :delete_image
    end
    member { get 'choose_hero', as: :choose_hero }
    resources :places, controller: :places_stories
    resources :attractions, controller: :attractions_stories
    resources :regions, controller: :regions_stories
    resources :countries, controller: :countries_stories
    resources :subcategories, controller: :stories_subcategories
  end

  post 'stories/autosave', as: :autosave_story_path

  get 'stories_all' => 'stories#index_new'

  mount API::Base => '/'
  mount GrapeSwaggerRails::Engine => '/apidoc'

  resources :bug_posts

  mount Ckeditor::Engine => '/ckeditor'
  post '/rate' => 'rater#create', :as => 'rate'
  constraints(SSConstraint.new) do
    get '/', to: 'places#programsearch', as: nil
  end

  constraints(BRConstraint.new) do
    get '/', to: 'pages#index', as: :root
  end

  get 'pages/terms' => 'pages#terms'
  get 'pages/privacy' => 'pages#privacy'
  get '/robots.txt' => 'pages#robots'


  resources :transactions

  resources :custom_reports do
    collection { get "photo_errors"}
  end

  require 'sidekiq/web'

  mount Sidekiq::Web => '/sidekiq'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  mount Bootsy::Engine => '/bootsy', as: 'bootsy'

  mount Soulmate::Server, :at => "/sm"

  get 'factual_places/search' => 'factual_places#search'

  get 'results' => 'search_suggestions#index', as: 'searching'
  get 'results/:sub_cat_id' => 'search_suggestions#index', as: 'searching_sub_cat'
  get 'nearby' => 'search_suggestions#nearby', as: 'searching_nearby'

  post 'searchqueries/create' => 'search_queries#create'
  post 'pages/want_notification' => 'pages#want_notification'
  get "areas/mapdata" => "areas#mapdata"
  get "areas/search" => "areas#search"
  get "places/mapdata" => "places#mapdata"
  get "places/placeareasmapdata" => "places#placeareasmapdata"
  get "places/search" => "places#search"
  get "places/subcategory_match_test" => "places#subcategory_match_test"
  get "places/subcategory_match" => "places#subcategory_match"
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
  post 'attractions_users/create' => 'attractions_users#create'
  post 'attractions_users/destroy' => 'attractions_users#destroy'
  post 'regions_users/create' => 'regions_users#create'
  post 'regions_users/destroy' => 'regions_users#destroy'
  post 'countries_users/create' => 'countries_users#create'
  post 'countries_users/destroy' => 'countries_users#destroy'
  post 'videos_users/create' => 'videos_users#create'
  post 'videos_users/destroy' => 'videos_users#destroy'
  post 'user_photos_users/create' => 'user_photos_users#create'
  post 'user_photos_users/destroy' => 'user_photos_users#destroy'
  post 'stories_users/create' => 'stories_users#create'
  post 'stories_users/destroy' => 'stories_users#destroy'
  post 'reviews_users/create' => 'reviews_users#create'
  post 'reviews_users/destroy' => 'reviews_users#destroy'
  post 'posts_users/create' => 'posts_users#create'
  post 'posts_users/destroy' => 'posts_users#destroy'

  resources :user_photos do
    member { put 'place_update' }
  end
  post 'user_photos/profile_create' => 'user_photos#profile_create'

  get 'stamp_transactions/stamp_here' => 'stamp_transactions#stamp_here'
  get 'stamp_transactions/stamp_error' => 'stamp_transactions#stamp_error'
  resources :stamp_transactions

  devise_for :users, :controllers => { :passwords => "passwords", :registrations => "registrations", :omniauth_callbacks => "users/omniauth_callbacks", :sessions => "sessions"}

  devise_scope :user do
    get "/sign_in" => "devise/sessions#new"
    get '/users/sign_out' => 'devise/sessions#destroy'
    put 'users/:id' => 'users#update'
    post '/update_password_user' =>  'users/user_password#update_password'
  end

  resources :pages do
    collection { get 'all_pages' }
    collection { get 'paginate_places'}
  end

  get '/google_map_home' => 'pages#google_map_home'

  get '/puzzles/:action' => 'puzzles#:action'

  get '/users/videos' => 'users#videos'
  get '/users/places' => 'users#places'
  get '/users/fun_facts' => 'users#fun_facts'
  get '/users/instagram_feed' => 'users#instagram_feed'
  get '/users/draft_content' => 'users#draft_content' # All User Uploaded Content in Draft

  resources :users do
    collection { get 'leaderboard' }
    member { get 'paginate_stories'}
    member { get 'paginate_places'}
    member { get 'paginate_place_to_visit'}
    member { get 'favourites' }
    member { get 'paginate_reviews' }
    member { get 'paginate_photos' }
    member { get 'photos' }
    member { get 'reviews' }
    member { get 'stories' }
    member { get 'public_profile' }
  end



  resources :three_d_videos

  resources :photos do
    collection { post :import }
    member { put 'place_update' }
    member { put 'attraction_update' }
    member { put 'region_update' }
    member { put 'story_update' }
    member { put 'country_update' }
  end

  resources :videos do
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
    member do
      get 'paginate_videos', as: :paginate_videos
      get 'paginate_photos', as: :paginate_photos
      get 'paginate_stories'
      get 'paginate_things_to_do'
      get 'paginate_deals'
      get 'seo_analysis'
      get 'choose_hero', as: :choose_hero
    end
    resources :good_to_knows
    resources :stories
    resources :deals
    resources :info_bits do
      collection { get 'all' }
    end
    resources :videos do
      collection { get 'all' }
    end
    resources :famous_faces do
      collection { get 'all' }
    end
    resources :photos do
      collection { get 'all_photos' }
    end
    resources :fun_facts do
      collection { get 'all' }
    end
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

  get "/primary_categories/cms_index", to: "primary_categories#cms_index"
  get "/subcategories/cms_index", to: "subcategories#cms_index"
  get "categories", to: "categories#index"

  resources :primary_categories

  resources :subcategories do
    collection do
      get 'specific/:age_ranges', action: 'specific', as: :specific, constraints: Routes::Constraints::Subcategories.new
    end
  end

  resources :places do
    member do
      get 'preview'
      get 'stamp_confirmation'
      get 'choose_hero', as: :choose_hero
      get 'paginate_videos', as: :paginate_videos
      get 'paginate_photos', as: :paginate_photos
      get 'paginate_reviews'
      get 'paginate_more_places'
      get 'paginate_place_to_visit'
      get 'paginate_stories'
      get 'paginate_deals'
      get 'hero_image_picker'
      get 'seo_analysis'
    end
    collection do
      get 'places_with_subcategories'
      get 'areas_with_subcategories'
      get 'all_edited'
      get 'user_created'
      get 'merge'
      get 'edit_parents'
      post :import
      post :import_update
      post :import_subcategories
    end

    resources :stamps
    resources :photos do
      collection { get 'all_photos' }
    end
    resources :videos do
      collection { get 'all' }
    end
    resources :fun_facts do
      collection { get 'all' }
    end
    resources :discounts
    resources :reviews
    resources :stories
    resources :user_photos
    resources :three_d_videos
    resources :similar_places
    resources :good_to_knows
    resources :deals
  end

  resources :attractions do
    member do
      get 'choose_hero', as: :choose_hero
      get 'seo_analysis'
      get 'paginate_more_attractions'
      get 'paginate_videos', as: :paginate_videos
      get 'paginate_photos', as: :paginate_photos
      get 'paginate_reviews'
      get 'paginate_stories'
      get 'paginate_deals'
    end
    resources :photos do
      collection { get 'all_photos' }
    end
    resources :videos do
      collection { get 'all' }
    end
    resources :fun_facts do
      collection { get 'all' }
    end
    resources :reviews
    resources :user_photos
    resources :three_d_videos
    resources :similar_attractions
    resources :good_to_knows
    resources :deals
    collection { post :import }
    collection { post :import_update }
    collection { post :import_subcategories }
  end

  resources :regions do 
    member { get 'choose_hero', as: :choose_hero }
    member { get 'paginate_place_to_visit'}
    member { get 'paginate_place_to_go'}
    member { get 'paginate_stories'}
    resources :photos do
      collection { get 'all_photos' }
    end
    resources :videos do
      collection { get 'all' }
    end
    resources :fun_facts do
      collection { get 'all' }
    end
  end

  resources :deals

  get '/places/:id/update_hero/:type/:photo_id' => 'places#update_hero'
  get '/attractions/:id/update_hero/:type/:photo_id' => 'attractions#update_hero'
  get '/stories/:id/update_hero/:type/:photo_id' => 'stories#update_hero'
  get '/regions/:id/update_hero/:type/:photo_id' => 'regions#update_hero'
  get '/countries/:id/update_hero/:type/:photo_id' => 'countries#update_hero'
  post 'search_requests/create'

  match '/:corppath', to: redirect("http://corporate.boundround.com/%{corppath}"), via: [:get, :post]

  post '/places/transfer_assets' => 'places#transfer_assets'
  get '/places/:id/new_edit' => 'places#new_edit'
  get '/places/:id/refresh_blog' => 'places#refresh_blog'

  post '/searchables/algolia-click/:object_id' => 'searchables#algolia_click', as: 'algolia_click'
end
