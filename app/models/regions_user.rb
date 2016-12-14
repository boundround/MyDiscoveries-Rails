class RegionsUser < ActiveRecord::Base
	belongs_to :region
	belongs_to :user
end
