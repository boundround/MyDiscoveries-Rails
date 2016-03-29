class Stamp < ActiveRecord::Base
	validates :serial, uniqueness: true

	belongs_to :place
	has_many :stamp_transactions
end
