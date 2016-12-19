class Order < ActiveRecord::Base
  belongs_to :offer
  belongs_to :user

  validates_presence_of :offer
  validates_presence_of :user
  validates_presence_of :title

  validates :number_of_infants,  numericality: { greater_than_or_equal: 0 }
  validates :number_of_children, numericality: { greater_than_or_equal: 0 }
  validates :number_of_adults,   numericality: { greater_than_or_equal: 0 }

  validate :check_total_people_count

  def total_people_count
    number_of_infants + number_of_children + number_of_adults
  end

  private

  def check_total_people_count
    if !offer.try(:minUnits).to_i.zero? && total_people_count < offer.try(:minUnits)
      errors.add(:total_people_count, "should be great than #{offer.minUnits}")
    elsif !offer.try(:maxUnits).to_i.zero? && total_people_count > offer.try(:maxUnits)
      errors.add(:total_people_count, "should be less than #{offer.maxUnits}")
    end
  end

end