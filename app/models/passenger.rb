class Passenger < ActiveRecord::Base
  TITLES = [[ 'Mrs', 'mrs' ],[ 'Ms', 'ms' ],[ 'Mr', 'mr' ]]

  belongs_to :order, class_name: Spree::Order

  validates :first_name, :last_name, :order, :date_of_birth, presence: true
end
