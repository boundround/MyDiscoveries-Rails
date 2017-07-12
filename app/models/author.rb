class Author < ActiveRecord::Base

	mount_uploader :image, AuthorImgUploader

	has_many :stories
	has_many :authors_users
	has_many :users, through: :authors_users
end
