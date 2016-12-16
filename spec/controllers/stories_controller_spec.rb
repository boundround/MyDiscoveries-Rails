# require 'rails_helper'
#
# RSpec.describe StoriesController, type: :controller do
#
#   before do
#     @user1 = FactoryGirl.create(:user, :admin)
#     @user2 = FactoryGirl.create(:user, :regular)
#     @user1.confirm
#     @user2.confirm
#     sign_in @user1
#   end
#
#   describe "GET #new" do
#     context "current user is admin " do
#       it "admin be allowed to access new story page" do
#         get :new
#         sign_in @user1
#         expect(@user1.admin).to be true
#         expect(response).to have_http_status(:success) # should be to new story path
#       end
#     end
#   end
#
#   describe "POST #create" do
#     context "current user is admin " do
#       it "Admin be allowed to create new story" do
#         post :create, story: {content: Faker::Lorem.sentence, title: Faker::Book.title, user_id: @user1.id, publish_date: Time.now, seo_friendly_url: Faker::Internet.url, status: "live"}
#         Story.last.user_id.should be @user1.id
#       end
#     end
#   end
#
#   describe "GET #edit" do
#     context "current user is admin " do
#       it "admin be allowed to access edit story page" do
#         story = Story.create(content: Faker::Lorem.sentence, title: Faker::Book.title, user_id: @user1.id, publish_date: Time.now, seo_friendly_url: Faker::Internet.url, status: "live")
#         get :edit, id: story.id
#         expect(@user1.admin).to be true
#         expect(response).to have_http_status(:success) # should be to edit story path
#       end
#     end
#   end
#
#   describe "POST #update" do
#     context "current user is admin " do
#       it "admin be allowed to update story that they have written" do
#         story = Story.create(content: Faker::Lorem.sentence, title: Faker::Book.title, user_id: @user1.id, publish_date: Time.now, seo_friendly_url: Faker::Internet.url, status: "live")
#         post :update, id: story.id, current_user: @user, story: {content: Faker::Lorem.sentence, title: Faker::Book.title, user_id: @user1.id, publish_date: Time.now, seo_friendly_url: Faker::Internet.url, status: "draft"}
#         Story.last.user_id.should be @user1.id
#       end
#     end
#   end
#
#   describe "GET #new" do
#     context "current user is user default" do
#       it "user default not allowed to access new story page" do
#         sign_in @user2
#         get :new
#         expect(@user2.admin).to be false
#         expect(response).not_to have_http_status(:unauthorized)# should be to root path
#       end
#     end
#   end
#
#   describe "GET #edit" do
#     context "current user is user default" do
#       it "user default not allowed to access edit story page" do
#         story = Story.create(content: Faker::Lorem.sentence, title: Faker::Book.title, user_id: @user1.id, publish_date: Time.now, seo_friendly_url: Faker::Internet.url, status: "live")
#         get :edit, id: story.id
#         expect(@user2.admin).to be false
#         expect(response).not_to have_http_status(:unauthorized) # should be to root path
#       end
#     end
#   end
#
#   describe "GET #show" do
#     context "current user show story with slug has been changed" do
#       it "current user redirect to another random story" do
#         story = Story.create(content: Faker::Lorem.sentence, title: Faker::Book.title, user_id: @user1.id, publish_date: Time.now, seo_friendly_url: Faker::Internet.url, status: "live")
#         get :show, id: story.id
#         expect(story).not_to be :found
#         expect(response).to have_http_status(:moved_permanently) # should be to another random story path
#       end
#     end
#   end
#
# end
