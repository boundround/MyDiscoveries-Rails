require 'rails_helper'

RSpec.describe PlacesController, type: :controller do


  describe "GET #show" do
    context "current user show place with slug has been changed" do
      it "current user redirect to another random place" do
        place = Place.create(description: 'dess', code: 'code', identifier: 'iden', display_name: 'place name', area_id: 1, slug: 'place-name')
        get :show, id: place.id
        expect(place).not_to be :found
        expect(response).to have_http_status(:moved_permanently) # should be to another random place path 
      end
    end
  end

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
      expect(response.body).to eq ""
    end
  end

  describe "GET #edit" do
    it "returns http success" do
      # get :edit
      # expect(response).to have_http_status(:success)
    end
  end

  describe "GET #update" do
    it "returns http success" do
      # get :update
      # expect(response).to have_http_status(:success)
    end
  end

  describe "GET #destroy" do
    it "returns http success" do
      # get :destroy
      # expect(response).to have_http_status(:success)
    end
  end

end
