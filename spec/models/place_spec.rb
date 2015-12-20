require 'rails_helper'

describe Place do
  before(:all) do
    place = Place.create(display_name: "Test Place")
  end

  it "has a bound round place id" do
    place = Place.find_by display_name: "Test Place"
    expect(place.bound_round_place_id).not_to be_empty
  end

  after(:all) do
    place = Place.find_by display_name: "Test Place"
    place.destroy
  end
end
