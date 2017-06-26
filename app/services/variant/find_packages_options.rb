class Variant::FindPackagesOptions
  include Service

  initialize_with_parameter_assignment :product, :options

  def call
    { variants: variants, options_selected: options_selected? }
  end

  private

  def variants
    search_params = {}
     if !product.disable_bed_type? && bed_type_present?
       search_params[:bed_type] =
        Spree::Variant.bed_types[options[:bed_type].downcase.to_sym]
     end
    if !product.disable_maturity? && maturity_present?
      search_params[:maturity] =
        Spree::Variant.maturities[options[:maturity].downcase.to_sym]
    end
    if !product.disable_departure_date && departure_date_present?
      search_params[:departure_date] = DateTime.parse(options[:departure_date])
    end

    result = product.variants.where(search_params)

    if !product.disable_room_type? && room_type_present?
      result = result.where('lower(room_type) = ?', options[:room_type].downcase)
    end

    if !product.disable_departure_city && departure_city_present?
      result = result.where('lower(departure_city) = ?', options[:departure_city].downcase)
    end

    if !product.disable_package_option && package_option_present?
      result = result.where('lower(package_option) = ?', options[:package_option].downcase)
    end

    if !product.disable_accommodation && accommodation_present?
      result = result.where('lower(accommodation) = ?', options[:accommodation].downcase)
    end

    result
  end

  def bed_type_present?
    @bed_type_present ||= options[:bed_type].present?
  end

  def departure_city_present?
    @departure_city_present ||= options[:departure_city].present?
  end

  def room_type_present?
    @room_type_present ||= options[:room_type].present?
  end

  def maturity_present?
    @maturity_present ||= options[:maturity].present?
  end

  def package_option_present?
    @package_option_present ||= options[:package_option].present?
  end

  def accommodation_present?
    @accommodation_present ||= options[:accommodation].present?
  end

  def departure_date_present?
    @departure_date_present ||= options[:departure_date].present?
  end

  # def base_options_present?
  #   departure_city_present? &&
  #   departure_date_present? &&
  #   package_option_present? &&
  #   accommodation_present?
  # end

  def options_selected?
    bed_type  = (!product.disable_bed_type? ? bed_type_present? : true)
    maturity  = (!product.disable_maturity? ? maturity_present? : true)
    room_type = (!product.disable_room_type? ? room_type_present? : true)
    departure_city = (!product.disable_departure_city? ? departure_city_present? : true)
    package_option = (!product.disable_package_option? ? package_option_present? : true)
    accommodation = (!product.disable_accommodation? ? accommodation_present? : true)
    departure_date = (!product.disable_departure_date? ? departure_date_present? : true)
    bed_type && maturity && room_type && departure_city && departure_date && package_option && accommodation
  end
end
