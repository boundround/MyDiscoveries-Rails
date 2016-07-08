require 'rails_helper'

describe Place do
  before(:all) do
    place = Place.find 233 #Taronga Zoo
  end

  it "has a bound round place id" do
    place = Place.find 233
    expect(place.bound_round_place_id).not_to be_empty
  end

  it "has a nil trip advisor rating" do
    place = Place.find 233
    expect(place.trip_advisor_info).to_be nil
  end
end
