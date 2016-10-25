require 'rails_helper'

RSpec.describe AttractionsController, type: :controller do

  before do
    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    # @user1.confirm
    # @user2.confirm
    sign_in @user1
  end
  
  describe "GET #index" do
    context "current user admin true show all attraction" do
      it "admin will show all list attraction" do
        get :index
        expect(@user1.admin).to be true
        expect(response).to have_http_status(:success) # should be to show all attractions
      end
    end
  end

  describe "GET #new" do
    context "current user is admin " do
      it "admin be allowed to access new attraction page" do
        get :new
        expect(@user1.admin).to be true
        expect(response).to have_http_status(:success) # should be to new attraction path
      end
    end
  end

  describe "POST #create" do
    context "current user is admin " do
      it "Admin be allowed to create new attraction" do
        display_name = Faker::Commerce.product_name
        icon = Faker::Avatar.image("my-own-slug", "50x50", "bmp", "set1", "bg1")
        post :create, attraction: {
          description: Faker::Lorem.sentence, code: display_name.first(3).upcase, identifier: display_name.split(' ').first.downcase, display_name: display_name, 
          subscription_level: 'basic', icon: 'my-own-slug', map_icon: icon, passport_icon: icon, created_at: DateTime.now, updated_at: DateTime.now, 
          slug: display_name.downcase.gsub(' ', '_'), latitude: '34.0522342', longitude: '-118.2436849', address: 'Los Angeles, CA, USA', 
          opening_hours: 'Open 7 days\n10:00am – 5:00pm', phone_number: "+876456", website: '', logo: icon, url: '', display_address: 'Los Angeles, CA, USA', booking_url: '', 
          post_code: Faker::Address.postcode, street_number: Faker::Address.street_address, route: '', sublocality: '', locality: '', state: Faker::Address.state,
          status: 'live', published_at: DateTime.now, unpublished_at: '', user_created: false, created_by: @user1.id, customer_review: false, 
          customer_approved: true, approved_at: DateTime.now, show_on_school_safari: false, school_safari_description: '', hero_image: icon, 
          bound_round_place_id: '', is_area: false, short_description: Faker::Lorem.sentence, weather_conditions: '', minimum_age: 5, maximum_age: 12, 
          special_requirements: '', top_100: false, viator_link: '', footer_include: true, primary_area: false, algolia_id: '', 
          email: Faker::Internet.free_email, parent_id: 22, trip_advisor_url: '', page_ranking_weight: '', algolia_clicks: '', area_id: '', 
          country_id: 1, user_id: @user1.id, primary_category_id: 1
        }
        # expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET #edit" do
    context "current user is admin " do
      it "admin be allowed to access edit attraction page" do
        display_name = Faker::Commerce.product_name
        icon = Faker::Avatar.image("my-own-slug", "50x50", "bmp", "set1", "bg1")
        attraction = Attraction.create!(description: Faker::Lorem.sentence, code: display_name.first(3).upcase, identifier: display_name.split(' ').first.downcase, display_name: display_name, 
          subscription_level: 'basic', icon: 'my-own-slug', map_icon: icon, passport_icon: icon, created_at: DateTime.now, updated_at: DateTime.now, 
          slug: display_name.downcase.gsub(' ', '_'), latitude: '34.0522342', longitude: '-118.2436849', address: 'Los Angeles, CA, USA', 
          opening_hours: 'Open 7 days\n10:00am – 5:00pm', phone_number: "+876456", website: '', logo: icon, url: '', display_address: 'Los Angeles, CA, USA', booking_url: '', 
          post_code: Faker::Address.postcode, street_number: Faker::Address.street_address, route: '', sublocality: '', locality: '', state: Faker::Address.state,
          status: 'live', published_at: DateTime.now, unpublished_at: '', user_created: false, created_by: @user1.id, customer_review: false, 
          customer_approved: true, approved_at: DateTime.now, show_on_school_safari: false, school_safari_description: '', hero_image: icon, 
          bound_round_place_id: '', is_area: false, short_description: Faker::Lorem.sentence, weather_conditions: '', minimum_age: 5, maximum_age: 12, 
          special_requirements: '', top_100: false, viator_link: '', footer_include: true, primary_area: false, algolia_id: '', 
          email: Faker::Internet.free_email, parent_id: 22, trip_advisor_url: '', page_ranking_weight: '', algolia_clicks: '', area_id: '', 
          country_id: 1, user_id: @user1.id, primary_category_id: 1
        )
        get :edit, id: attraction.id
        expect(@user1.admin).to be true
        expect(response).to have_http_status(:success) # should be to edit attraction path
      end
    end
  end

  describe "POST #update" do
    context "current user is admin " do
      it "Admin be allowed to update attraction" do
        display_name = Faker::Commerce.product_name
        icon = Faker::Avatar.image("my-own-slug", "50x50", "bmp", "set1", "bg1")
        attraction = Attraction.create!(description: Faker::Lorem.sentence, code: display_name.first(3).upcase, identifier: display_name.split(' ').first.downcase, display_name: display_name, 
          subscription_level: 'basic', icon: 'my-own-slug', map_icon: icon, passport_icon: icon, created_at: DateTime.now, updated_at: DateTime.now, 
          slug: display_name.downcase.gsub(' ', '_'), latitude: '34.0522342', longitude: '-118.2436849', address: 'Los Angeles, CA, USA', 
          opening_hours: 'Open 7 days\n10:00am – 5:00pm', phone_number: "+876456", website: '', logo: icon, url: '', display_address: 'Los Angeles, CA, USA', booking_url: '', 
          post_code: Faker::Address.postcode, street_number: Faker::Address.street_address, route: '', sublocality: '', locality: '', state: Faker::Address.state,
          status: 'live', published_at: DateTime.now, unpublished_at: '', user_created: false, created_by: @user1.id, customer_review: false, 
          customer_approved: true, approved_at: DateTime.now, show_on_school_safari: false, school_safari_description: '', hero_image: icon, 
          bound_round_place_id: '', is_area: false, short_description: Faker::Lorem.sentence, weather_conditions: '', minimum_age: 5, maximum_age: 12, 
          special_requirements: '', top_100: false, viator_link: '', footer_include: true, primary_area: false, algolia_id: '', 
          email: Faker::Internet.free_email, parent_id: 22, trip_advisor_url: '', page_ranking_weight: '', algolia_clicks: '', area_id: '', 
          country_id: 1, user_id: @user1.id, primary_category_id: 1, run_rake: true
        )
        # post :update, id: attraction.id, attraction: {
        #   description: Faker::Lorem.sentence, code: display_name.first(3).upcase, identifier: display_name.split(' ').first.downcase, display_name: display_name, 
        #   subscription_level: 'basic', icon: 'my-own-slug', map_icon: icon, passport_icon: icon, created_at: DateTime.now, updated_at: DateTime.now, 
        #   slug: display_name.downcase.gsub(' ', '_'), latitude: '34.0522342', longitude: '-118.2436849', address: 'Los Angeles, CA, USA', 
        #   opening_hours: 'Open 7 days\n10:00am – 5:00pm', phone_number: "+876456", website: '', logo: icon, url: '', display_address: 'Los Angeles, CA, USA', booking_url: '', 
        #   post_code: Faker::Address.postcode, street_number: Faker::Address.street_address, route: '', sublocality: '', locality: '', state: Faker::Address.state,
        #   status: 'live', published_at: DateTime.now, unpublished_at: '', user_created: false, created_by: @user1.id, customer_review: false, 
        #   customer_approved: true, approved_at: DateTime.now, show_on_school_safari: false, school_safari_description: '', hero_image: icon, 
        #   bound_round_place_id: '', is_area: false, short_description: Faker::Lorem.sentence, weather_conditions: '', minimum_age: 5, maximum_age: 12, 
        #   special_requirements: '', top_100: false, viator_link: '', footer_include: true, primary_area: false, algolia_id: '', 
        #   email: Faker::Internet.free_email, parent_id: 22, trip_advisor_url: '', page_ranking_weight: '', algolia_clicks: '', area_id: '', 
        #   country_id: 1, user_id: @user1.id, primary_category_id: 2, run_rake: true
        # }
        # expect(response).to have_http_status(:success)
      end
    end
  end

end