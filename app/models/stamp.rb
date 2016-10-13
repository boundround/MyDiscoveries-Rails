class Stamp < ActiveRecord::Base
	validates :serial, uniqueness: true

	belongs_to :place
	belongs_to :attraction
	has_many :stamp_transactions
end
