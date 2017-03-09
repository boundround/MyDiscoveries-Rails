class Passenger < ActiveRecord::Base
  TITLES = ['Mrs', 'Mr']

  belongs_to :order, class_name: Spree::Order

  validates :first_name, :last_name, :order, :date_of_birth, presence: true
end
