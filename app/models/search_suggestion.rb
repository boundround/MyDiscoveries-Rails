class SearchSuggestion < ActiveRecord::Base

  #backup
  def self.terms_for_area(text, options= { page: 0, hitsPerPage: 6 })
    @areas = Place.is_area.includes(:area, :primary_category, :subcategories).raw_search(text, options)
  end
  
  def self.terms_for_place(text, options= { page: 0, hitsPerPage: 6 })
    @places = Place.is_not_area.includes(:area, :primary_category, :subcategories).raw_search(text, options)
  end

  def self.index_places
    Place.find_each do |place|
      index_term(place.display_name)
      place.display_name.split.each { |t| index_term(t) }
      place.description.split.each { |t| index_term(t) }
    end
  end

  def self.index_term(term)
    where(term: term.downcase).first_or_initialize.tap do |suggestion|
      suggestion.increment! :popularity
    end
  end

end
