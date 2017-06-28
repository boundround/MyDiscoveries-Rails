Spree::Variant.class_eval do

  enum maturity: { adult: 0, child: 1 } unless instance_methods.include? :maturity
  enum bed_type: { single: 0, twin: 1, triple: 2 } unless instance_methods.include? :bed_type

  default_scope { where(miscellaneous_charges: false) }

  before_validation :strip_fields

  validates_presence_of :room_type,
    if: Proc.new { |v| !v.product.disable_room_type? && !v.is_master? }
  validates_presence_of :departure_city,
    if: Proc.new { |v| !v.product.disable_departure_city? && !v.is_master? }
  validates_presence_of :departure_date,
    if: Proc.new { |v| !v.product.disable_departure_date? && !v.is_master? }
  validates_presence_of :package_option,
    if: Proc.new { |v| !v.product.disable_package_option? && !v.is_master? }
  validates_presence_of :accommodation,
    if: Proc.new { |v| !v.product.disable_accommodation? && !v.is_master? }

  validate :uniqueness,
    if: Proc.new { |v| !v.miscellaneous_charges? && !v.is_master? }

  # overrides default getter
  def description
    super
  end

  # overrides default setter
  def description=(value)
    super(value)
  end

  def select_label
    label = ""

    if !product.disable_departure_city
      label << "Departure city: #{departure_city.capitalize}"
    end

    if !product.disable_departure_date
      label << " Departure Date: #{departure_date.try(:to_date).try(:to_s)},"
    end

    if !product.disable_package_option
      label << " Package Option: #{package_option.try(:capitalize)},"
    end

    if !product.disable_accommodation
      " Hotel / Accommodation: #{accommodation.try(:capitalize)},"
    end

    if !product.disable_room_type
      label << " Room Type: #{room_type.try(:capitalize)},"
    end

    if !product.disable_bed_type
      label << " Bed Type: #{bed_type.try(:capitalize)},"
    end

    if !product.disable_maturity
      label << " Maturity: #{maturity.try(:capitalize)},"
    end

    label.gsub(/\,$/, '')
  end

  def monthly_price
    price / 5.0
  end

  def strip_fields
    departure_city.strip! unless departure_city.nil?
    room_type.strip!      unless room_type.nil?
    package_option.strip! unless package_option.nil?
    accommodation.strip!  unless accommodation.nil?
  end

  private

  def uniqueness
    Variant::UniquenessValidator.call(self)
  end
end
