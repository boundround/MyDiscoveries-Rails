class SearchSuggestionsController < ApplicationController

  include Locatable
  helper_method :filters

  def index
    @areas = SearchSuggestion.terms_for_area(search_params[:common],
                                             page: page_params(:areas_page),
                                             facets: 'is_area',
                                             facetFilters: ['is_area:true'],
                                             hitsPerPage: per_page_params(:per_page_areas))
    @places = SearchSuggestion.terms_for_place(search_params[:common],
                                               page: page_params(:places_page),
                                               facets: 'is_area',
                                               facetFilters: ['is_area:false'],
                                               hitsPerPage: per_page_params(:per_page_places))
    respond_to do |f|
      f.html
      f.js
    end
  end

  def nearby
    @places= Place.includes(:photos, :primary_category, :subcategories, :country).near(current_user_location, 100000).paginate(page: params[:page], per_page: 6)
    #@places= Place.includes(:photos, :primary_category, :subcategories, :country).all.paginate(page: params[:places_page], per_page: 6)
    respond_to do |f|
      f.html
      f.js
    end
  end

  private

  	def search_params
  		params[:search] ||= {}
  	end

    def page_params resource_name
      params[resource_name] ||= 0
    end

    def per_page_params resource_name
      params[resource_name] ||= 4
    end

    def filters
      return @filter if @filter
      @filter= {}
      @filter[:category]= PrimaryCategory.all
      @filter[:subcategory]= Subcategory.all
      @filter[:price]= [ Openstruct.new(name: "free", value: "0"), Openstruct.new(name: '$10 - $99', value: '10-99'), Openstruct.new(name: '$100 - $999', value: '100-999'), Openstruct.new(name: '$1000') ]
    end



end
