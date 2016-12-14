class SubCategoriesController < ApplicationController
  def show
  #hardcode #check
  @subcategory = PlacesSubcategory.find_by_identifier(params[:id])
  end

  def specific
    @areas= Place.filter(age_ranges_params).paginate page: params[:areas_page], per_page: 2
  end

  private
    def age_ranges_params
      if params[:age_ranges].present?
        ranges= params[:age_ranges].split('-')
        return { min_age: ranges.first.to_i, max_age: ranges.last.to_i } unless ranges.blank?
      end
    end
end
