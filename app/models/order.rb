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

  after_commit :set_ax_sales_id!, on: :create

  enum status: { created_in_boundround: 0, authorized: 1 }

  accepts_nested_attributes_for :passengers

  def total_people_count
    number_of_infants + number_of_children + number_of_adults
  end

  def monthly_price
    total_price / 5.0
  end

  def update_total_price!
    total_price = number_of_adults * offer.minRateAdult +
      number_of_children * (offer.minRateChild || offer.minRateAdult) +
      number_of_infants * (offer.minRateInfant || offer.minRateAdult)

    update(total_price: total_price) if self.total_price != total_price
  end

  def check_total_people_count
    if !offer.try(:minUnits).to_i.zero? && total_people_count < offer.try(:minUnits)
      errors.add(:total_people_count, "should be greater than #{offer.minUnits}")
    elsif !offer.try(:maxUnits).to_i.zero? && total_people_count > offer.try(:maxUnits)
      errors.add(:total_people_count, "should be less than #{offer.maxUnits}")
    end
  end

  def ax_line_items
    line_items = ax_data.try(:[], 'Envelope').
      try(:[], 'Order').
      try(:[], 'Items').
      try(:[], 'Item')

    return [] if line_items.blank?
    line_items.is_a?(Hash) ? [line_items] : line_items
  end

  def set_ax_sales_id!
    update_column(:ax_sales_id, "WM#{1000000 + id}") unless created_from_ax
  end
end
