require 'rails_helper'

RSpec.describe API::V1::PlacesController, type: :controller do
  describe "GET api/v1/places" do
    it "should get v1" do
      get '/api/v1/places', {}, {'Accept' => 'application/vnd.boundround.com; version=1'}
      assert_response 200
      assert_equal "v1", response.body
    end
  end
end
