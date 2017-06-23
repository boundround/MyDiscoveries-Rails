class Variant::UniquenessValidator
  include Service

  initialize_with_parameter_assignment :variant

  def call
    variant_uniq?
  end

  private

  def product
    @product ||= variant.product
  end

  def variant_uniq?
    if product.variants.where(query).any?
      variant.errors.add(:base, error_message)
      false
    else
      true
    end
  end

  def query
    options = {
      departure_city: variant.departure_city,
      departure_date: variant.departure_date,
      package_option: variant.package_option,
      accommodation:  variant.accommodation
    }

    options[:room_type] = variant.room_type unless product.disable_room_type
    options[:maturity]  = variant.maturity  unless product.disable_maturity
    options[:bed_type]  = variant.bed_type  unless product.disable_bed_type

    options
  end

  def error_message
    base_error = "Product variant should contain a unique combination of \
      Departure City, Departure Date, Package Option, Accommodation"

    base_error << ', Room Type' unless product.disable_room_type
    base_error << ', Maturity'  unless product.disable_maturity
    base_error << ', Bed Type'  unless product.disable_bed_type

    base_error
  end
end
