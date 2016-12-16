# require 'rails_helper'
#
# RSpec.describe SessionsController, type: :controller do
#
#   before do
#     @user1 = FactoryGirl.create(:user, :admin)
#     @user2 = FactoryGirl.create(:user, :regular)
#   end
#
#   describe "POST #create" do
#     context "User has been confirmed" do
#       it "User be allowed to login" do
#         @user1.confirm
#         sign_in @user1
#         expect(@user1.confirmed?).to be true
#         expect(@user1.confirmation_token).not_to be_empty
#         expect(response).to have_http_status(:success)
#       end
#     end
#   end
#
#   describe "POST #create" do
#     context "User not confirmed" do
#       it "User not allowed to login" do
#         sign_in @user2
#         expect(@user2.confirmed?).to be false
#         expect(@user2.confirmation_token).not_to be_empty
#         expect(response).to have_http_status(:success)
#       end
#     end
#   end
#
# end
