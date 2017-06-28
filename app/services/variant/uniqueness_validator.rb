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
    if query.empty?
      variant.errors.add(:base, error_empty_variant)
      false
    elsif variants.empty?
      true
    elsif variants.count > 1
      variant.errors.add(:base, error_message)
      false
    elsif variants.last != variant
      variant.errors.add(:base, error_message)
      false
    end
  end

  def variants
    @variants ||= product.variants.where(query)
  end

  def query
    options = {}

    if !product.disable_room_type
      options[:room_type] = variant.room_type
    end

    if !product.disable_maturity
      options[:maturity] =
        Spree::Variant.maturities[variant.maturity.downcase.to_sym]
    end

    if !product.disable_bed_type
      options[:bed_type] =
        Spree::Variant.bed_types[variant.bed_type.downcase.to_sym]
    end

    if !product.disable_departure_city
      options[:departure_city] = variant.departure_city
    end

    if !product.disable_departure_date
      options[:departure_date] = variant.departure_date
    end

    if !product.disable_package_option
      options[:package_option] = variant.package_option
    end

    if !product.disable_accommodation
      options[:accommodation] = variant.accommodation
    end

    options
  end

  def error_message
    base_error = 'Product variant should contain a unique combination of'

    base_error << ' Room Type,'      unless product.disable_room_type
    base_error << ' Maturity,'       unless product.disable_maturity
    base_error << ' Bed Type,'       unless product.disable_bed_type
    base_error << ' Departure Date,' unless product.disable_departure_date
    base_error << ' Departure City,' unless product.disable_departure_city
    base_error << ' Package Option,' unless product.disable_package_option
    base_error << ' Accommodation'   unless product.disable_accommodation

    # removes last comma
    base_error.gsub(/\,$/, '')
  end

  def error_empty_variant
    @error_empty_variant ||=
      'You can\'t create empty variant.
       At least one option must be chosen for a variant to be allowed.'
  end
end
