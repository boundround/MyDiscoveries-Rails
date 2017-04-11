class Variant::FindPackagesOptions
  include Service

  initialize_with_parameter_assignment :product, :options

  def call
    { variants: variants, options_selected: options_selected? }
  end

  private

  def variants
    search_params = {}
     if bed_type_present?
       search_params[:bed_type] =
        Spree::Variant.bed_types[options[:bed_type].downcase.to_sym]
     end
    if maturity_present?
      search_params[:maturity] =
        Spree::Variant.maturities[options[:maturity].downcase.to_sym]
    end
    if departure_city_present?
      search_params[:departure_city] = options[:departure_city]
    end

    product.variants.where(search_params)
  end

  def bed_type_present?
    @bed_type_present ||= options[:bed_type].present?
  end

  def departure_city_present?
    @departure_city_present ||= options[:departure_city].present?
  end

  def maturity_present?
    @maturity_present ||= options[:maturity].present?
  end

  def options_selected?
    @options_selected ||= departure_city_present? &&
      maturity_present? &&
      departure_city_present?
  end
end
