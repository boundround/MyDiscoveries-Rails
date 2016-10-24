require 'rails_helper'

RSpec.describe CountriesController, type: :controller do

  before do
    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    @user1.confirm
    @user2.confirm
    sign_in @user1
  end

  describe "GET #show" do
    context "current user show country with slug has been changed" do
      it "current user redirect to another random country" do
        country = Country.create(display_name: 'Indonesia', country_code: 'id', slug: 'code-id')
        get :show, id: country.id
        expect(country).not_to be :found
        expect(response).not_to have_http_status(:moved_permanently) # should be to another random country path 
      end
    end
  end

end
