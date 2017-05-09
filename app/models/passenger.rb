class Passenger < ActiveRecord::Base
  TITLES = [[ 'Mrs', 'mrs' ],[ 'Ms', 'ms' ],[ 'Mr', 'mr' ]]

  belongs_to :order, class_name: Spree::Order
  belongs_to :line_item, class_name: Spree::LineItem

  validates :first_name, :last_name, :order, :date_of_birth, presence: true
end
