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

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  resources :operators
  resources :competitions

  resources :posts do
    collection { get 'all_posts' }
    collection { get 'paginate' }
    member     { get 'paginate_place_to_visit' }
    resources :places, controller: :places_posts
    resources :countries, controller: :countries_posts
    resources :subcategories, controller: :posts_subcategories
  end

  resources :stories do
    collection do
      get 'paginate'
      post 'featured'
    end
    member do
      get 'seo_analysis'
      get 'paginate_place'
      post :upload_image
      post :delete_image
    end
    resources :photos do
      collection { get 'choose_hero', as: :choose_hero }
    end
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
    collection { get "photo_errors" }
  end

  require 'sidekiq/web'

  mount Sidekiq::Web => '/sidekiq'

  mount RailsAdmin::Engine => '/admin/info', as: 'rails_admin'

  mount Bootsy::Engine => '/bootsy', as: 'bootsy'

  mount Soulmate::Server, at: "/sm"

  mount ConfigurableEngine::Engine => '/admin/configurable', as: 'configurable'

  get 'terms-conditions' => 'posts#show', :defaults => { :id => 'terms-conditions' }
  get 'booking-guarantee' => 'posts#show', :defaults => { :id => 'booking-guarantee' }
  get 'frequently-asked-questions' => 'posts#show', :defaults => { :id => 'frequently-asked-questions' }
  get 'about-us' => 'posts#show', :defaults => { :id => 'about-us' }
  get 'privacy' => 'posts#show', :defaults => { :id => 'privacy' }

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

  # get "/sitemap" => redirect("https://s3-ap-southeast-2.amazonaws.com/brwebproduction/sitemaps/sitemap.xml.gz")

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
  post 'offers_users/create' => 'offers_users#create'
  post 'offers_users/destroy' => 'offers_users#destroy'
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

  devise_for :users, controllers: {
    passwords:          'passwords',
    registrations:      'registrations',
    omniauth_callbacks: 'users/omniauth_callbacks',
    sessions:           'sessions',
    confirmations:      'confirmations'
  }

  devise_scope :user do
    get "/sign_in" => "devise/sessions#new"
    get '/users/sign_out' => 'devise/sessions#destroy'
    put 'users/:id' => 'users#update'
    post '/update_password_user' =>  'users/user_password#update_password'
  end

  resources :pages do
    collection { get 'all_pages' }
    member { get 'paginate_places'}
    member { get 'paginate_stories'}
    member { get 'paginate_offers'}
  end

  get '/google_map_home' => 'pages#google_map_home'

  get '/puzzles/:action' => 'puzzles#:action'

  get '/users/videos' => 'users#videos'
  get '/users/places' => 'users#places'
  get '/users/fun_facts' => 'users#fun_facts'
  get '/users/instagram_feed' => 'users#instagram_feed'
  get '/users/draft_content' => 'users#draft_content' # All User Uploaded Content in Draft

  resources :users do
    collection do
      get 'leaderboard'
      post 'confirm'
    end
    member do
      get 'paginate_stories'
      get 'paginate_favorite_stories'
      get 'paginate_places'
      get 'paginate_offers'
      get 'paginate_regions'
      get 'paginate_place_to_visit'
      get 'favourites'
      get 'paginate_reviews'
      get 'paginate_photos'
      get 'paginate_orders'
      get 'photos'
      get 'reviews'
      get 'stories'
      get 'public_profile'
    end
  end
  resources :landings



  resources :three_d_videos

  resources :photos do
    collection { post :import }
    member { put 'place_update' }
    member { put 'attraction_update' }
    member { put 'region_update' }
    member { put 'story_update' }
    member { put 'country_update' }
    member { put 'offer_update' }
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
      collection { get 'choose_hero', as: :choose_hero }
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
    member do
      get 'paginate_offers'
      get 'paginate_stories'
    end
    collection do
      get 'specific/:age_ranges', action: 'specific', as: :specific, constraints: Routes::Constraints::Subcategories.new
    end
  end

  resources :places do
    member do
      get 'preview'
      get 'stamp_confirmation'
      get 'paginate_videos', as: :paginate_videos
      get 'paginate_photos', as: :paginate_photos
      get 'paginate_reviews'
      get 'paginate_more_places'
      get 'paginate_place_to_visit'
      get 'paginate_stories'
      get 'paginate_deals'
      get 'paginate_offers'
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
      collection { get 'choose_hero', as: :choose_hero }
    end
    resources :videos do
      collection { get 'all' }
    end
    resources :fun_facts do
      collection { get 'all' }
    end
    resources :tab_infos do
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
      get 'seo_analysis'
      get 'paginate_more_attractions'
      get 'paginate_videos', as: :paginate_videos
      get 'paginate_photos', as: :paginate_photos
      get 'paginate_reviews'
      get 'paginate_stories'
      get 'paginate_deals'
    end
    resources :photos do
      collection { get 'choose_hero', as: :choose_hero }
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
    member { get 'paginate_place_to_visit'}
    member { get 'paginate_place_to_go'}
    member { get 'paginate_stories'}
    member { get 'paginate_offers'}
    member { get 'paginate_countries'}
    resources :photos do
      collection { get 'choose_hero', as: :choose_hero }
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
  resources :authors
  
  resources :offers do
    member do
      get 'paginate_videos', as: :paginate_videos
      get 'paginate_photos', as: :paginate_photos
      get 'load_options'
    end
    collection { get 'paginate_on_idx' }
    collection { get 'paginate_offers' }
    collection do
      get 'new_livn_offer'
      post 'create_livn_offer'
      get 'cms_index'
    end
    resources :videos do
      collection { get 'all' }
    end
    resources :photos do
      collection { get 'choose_hero', as: :choose_hero }
      collection { get 'all_photos' }
    end
    resources :orders, only: [ :new, :edit, :create, :update ] do
      collection do
        get :add
        post :populate
        patch :delete_line_item
      end
    end
    resources :places, controller: :places_offers
    resources :attractions, controller: :attractions_offers
    resources :regions, controller: :regions_offers
    resources :countries, controller: :countries_offers
    resources :subcategories, controller: :subcategories_offers
    resources :related_offers
    resources :stickers, controller: :products_stickers
    member do
      get 'paginate_media'
      get 'paginate_reviews'
    end
    resources :reviews
    resources :variants do
      collection do
        post :fill_packages_options
      end
      member do
        get :miscellaneous_charge
        post :process_miscellaneous_charge
      end
    end
    resources :add_ons
  end

  resources :stickers
  resources :variants do
    collection { post :import }
  end
  resources :promotions

  get 'cart' => 'orders#cart'
  put 'empty_cart' => 'orders#empty'
  get 'offers/:offer_id/line_items/:line_item_id/add_passengers' => 'orders#add_passengers',
    as: :line_item_add_passengers
  patch 'offers/:offer_id/line_items/:line_item_id' => 'orders#update_passengers',
    as: :line_item_update_passengers
  get 'checkout' => 'orders#checkout', as: :checkout
  post 'payment' => 'orders#payment', as: :payment
  put 'orders/update_line_items' => 'orders#update_line_items', as: :update_cart
  get 'orders/:id/send_to_sna' => 'orders#send_to_sna', as: :order_send_to_sna
  get 'orders/:id/view_confirmation' => 'orders#view_confirmation',
    as: :order_view_confirmation
  get 'orders/:id/edit_confirmation' => 'orders#edit_confirmation',
    as: :order_edit_confirmation
  patch 'orders/:id/update_customer' => 'orders#update_customer',
    as: :order_update_customer
  get 'orders/:id/cms_edit' => 'orders#cms_edit',
    as: :order_cms_edit
  get 'orders/:id/customer_info' => 'orders#customer_info',
    as: :order_customer_info
  patch 'orders/:id/cms_update' => 'orders#cms_update',
    as: :order_cms_update
  get 'orders/:id/confirmation' => 'orders#confirmation',
    as: :order_confirmation
  get 'orders/:id/resend_confirmation' => 'orders#resend_confirmation',
    as: :order_resend_confirmation
  get 'orders/:id/edit_line_items' => 'orders#edit_line_items',
    as: :order_edit_line_items
  get 'orders/:id/update_departure_date' => 'orders#update_departure_date',
    as: :order_update_departure_date

  get 'orders' => 'orders#index'
  get 'orders/abandoned' => 'orders#abandoned', as: :abandoned_orders

  get '/places/:id/update_hero/:type/:photo_id' => 'places#update_hero'
  get '/attractions/:id/update_hero/:type/:photo_id' => 'attractions#update_hero'
  get '/stories/:id/update_hero/:type/:photo_id' => 'stories#update_hero'
  get '/regions/:id/update_hero/:type/:photo_id' => 'regions#update_hero'
  get '/countries/:id/update_hero/:type/:photo_id' => 'countries#update_hero'
  get '/offers/:id/update_hero/:type/:photo_id' => 'offers#update_hero'
  post 'search_requests/create'

  post '/places/transfer_assets' => 'places#transfer_assets'
  get '/places/:id/new_edit' => 'places#new_edit'
  get '/places/:id/refresh_blog' => 'places#refresh_blog'

  post '/searchables/algolia-click/:object_id' => 'searchables#algolia_click', as: 'algolia_click'

  get '/admin/configurable/booking_guarantee' => 'admin/configurables#book_guarantee'
  get '/admin/configurable/terms_and_conditions' => 'admin/configurables#terms_and_conditions'
  post '/admin/configurable' => 'admin/configurables#create', as: :configurables

end

# add dynamic routes
BoundRoundWeb::Application.routes.draw do
  DynamicRouter.load
end
