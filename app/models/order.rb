class Order < ActiveRecord::Base
  belongs_to :offer
  belongs_to :user
  belongs_to :customer

  has_many :passengers

  validates_presence_of :offer
  validates_presence_of :user
  validates_presence_of :title

  validates :number_of_infants,  numericality: { greater_than_or_equal: 0 }
  validates :number_of_children, numericality: { greater_than_or_equal: 0 }
  validates :number_of_adults,   numericality: { greater_than_or_equal: 0 }

  validate :check_total_people_count

  enum status: { created_in_boundround: 0, authorized: 1 }

  accepts_nested_attributes_for :passengers

  def total_people_count
    number_of_infants + number_of_children + number_of_adults
  end

  def monthly_price
    total_price / 5
  end

  def update_total_price!
    total_price = number_of_adults * offer.maxRateAdult +
      number_of_children * (offer.maxRateChild || offer.maxRateAdult) +
      number_of_infants * (offer.maxRateInfant || offer.maxRateAdult)

    update(total_price: total_price) if self.total_price != total_price
  end

  def check_total_people_count
    if !offer.try(:minUnits).to_i.zero? && total_people_count < offer.try(:minUnits)
      errors.add(:total_people_count, "should be greater than #{offer.minUnits}")
    elsif !offer.try(:maxUnits).to_i.zero? && total_people_count > offer.try(:maxUnits)
      errors.add(:total_people_count, "should be less than #{offer.maxUnits}")
    end
  end

  def purchase_date
    Date.parse px_response['Txn']['Transaction']['RxDate']
  end

  # salesId for Innovations
  def uniq_number
    "WM#{1000000 + id}"
  end

end
