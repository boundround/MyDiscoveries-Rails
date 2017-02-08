class Customer < ActiveRecord::Base
  TITLES = ['Mrs', 'Mr']

  belongs_to :user
  has_many :orders

  validates :user, :country, :email, :first_name, :last_name,
    :phone_number, :city, :state, :postal_code, :address_one, presence: true

  attr_accessor :credit_card

  def full_name
    "#{title} #{first_name} #{last_name}"
  end
end
