class Customer < ActiveRecord::Base
  TITLES = [[ 'Mrs', 'mrs' ],[ 'Ms', 'ms' ],[ 'Mr', 'mr' ]]

  belongs_to :user
  has_many :orders

  validates :country, :email, :first_name, :last_name,
    :phone_number, :city, :state, :postal_code, :address_one, presence: true

  attr_accessor :credit_card

  def full_name
    "#{title.titleize} #{first_name} #{last_name}"
  end

  # CustAccount for Innovations
  def uniq_number
    "M#{1000000 + id}"
  end

  def country_name
    (
      ISO3166::Country.find_country_by_alpha2(country) ||
      ISO3166::Country.find_country_by_alpha3(country)
    ).try(:name)
  end
end
