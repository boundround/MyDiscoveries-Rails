# require 'rails_helper'
#
# RSpec.describe UsersController, type: :controller do
#
#   before do
#     @user1 = FactoryGirl.create(:user, :admin)
#     @user2 = FactoryGirl.create(:user, :regular)
#     @role = FactoryGirl.create(:role)
#     @user1.confirm
#     @user2.confirm
#     sign_in @user1
#   end
#
#   describe "GET #edit" do
#     context "current user is admin " do
#       it "admin be allowed to access edit user page" do
#         get :edit, id: @user1.id
#         expect(@user1.admin).to be true
#         expect(response).to have_http_status(:success) # should be to edit user path
#       end
#     end
#   end
#
#   describe "POST #update" do
#     context "current user is admin " do
#       it "admin be allowed to update another user" do
#         post :update, id: @user2.id, current_user: @user1, user: {role_ids: [@role.id.to_s], is_private: "1"}
#         expect(@user1.admin).to be true
#         expect(User.last.is_private).to be false
#         expect(response).to have_http_status(:success)
#       end
#     end
#   end
#
#   describe "GET #edit" do
#     context "current user is admin " do
#       it "user default not allowed to access edit user page" do
#         sign_in @user2
#         get :edit, id: @user1.id
#         expect(@user2.admin).to be false
#         expect(response).not_to have_http_status(:success) # should not be to edit user path
#       end
#     end
#   end
# end
