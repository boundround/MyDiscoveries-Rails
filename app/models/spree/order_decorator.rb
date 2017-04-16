Spree::Order.class_eval do
  belongs_to :product
  belongs_to :customer

  # override spree relations
  belongs_to :user,       class_name: 'User'
  belongs_to :created_by, class_name: 'User'
  belongs_to :approver,   class_name: 'User'
  belongs_to :canceler,   class_name: 'User'


  has_many :passengers

  validates_presence_of :product, on: :update
  validates_presence_of :user, on: :update
  validates_presence_of :title, on: :update

  validates :number_of_infants,  numericality: { greater_than_or_equal: 0 }
  validates :number_of_children, numericality: { greater_than_or_equal: 0 }
  validates :number_of_adults,   numericality: { greater_than_or_equal: 0 }

  validate :check_total_people_count

  after_commit :set_ax_sales_id!, on: :create

  accepts_nested_attributes_for :passengers

  def total_people_count
    number_of_infants + number_of_children + number_of_adults
  end

  def monthly_price
    total_price / 5.0
  end

  def update_total_price!
    total_price = number_of_adults * product.minRateAdult +
      number_of_children * (product.minRateChild || product.minRateAdult) +
      number_of_infants * (product.minRateInfant || product.minRateAdult)

    update(total_price: total_price) if self.total_price != total_price
  end

  def check_total_people_count
    if !product.try(:minUnits).to_i.zero? && total_people_count < product.try(:minUnits)
      errors.add(:total_people_count, "should be great than #{product.minUnits}")
    elsif !product.try(:maxUnits).to_i.zero? && total_people_count > product.try(:maxUnits)
      errors.add(:total_people_count, "should be less than #{product.maxUnits}")
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
    update_column(:ax_sales_id, "WM#{1000000 + id}") unless created_from_ax && ax_sales_id.present?
  end
end
