class UserPhotosUser < ActiveRecord::Base
  belongs_to :user_photo
  belongs_to :user
end
