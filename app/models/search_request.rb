class SearchRequest < ActiveRecord::Base

	validates_presence_of :name, :email, :term

	validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }


end
