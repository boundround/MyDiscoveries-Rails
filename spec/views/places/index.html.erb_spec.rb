# require "rails_helper"
# include Devise::Test::ControllerHelpers
#
# RSpec.describe "places/index" do
#   it "displays error if not logged in as admin" do
#
#     render
#
#     expect(rendered).to match /permissions/i
#   end
#
#   before(:each) do
#     user = User.find 15
#     sign_in user
#   end
#   it "displays all places if logged in as admin" do
#
#     render
#
#     expect(rendered).to match /sydney/i
#   end
# end
