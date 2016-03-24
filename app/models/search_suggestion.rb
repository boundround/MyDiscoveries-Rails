class SearchSuggestion < ActiveRecord::Base

  #backup
  def self.terms_for(prefix)
    @places = Place.where(status: "live").includes(:area, :primary_category, :subcategories)
             .raw_search(prefix)

    # @places = Place.where("display_name @@ :q or description @@ :q", q: params[:term])

    @places = ActiveSupport::JSON.decode(@places.to_json)
  end
  #backup-end

  # def self.terms_for(prefix)
  #   @places = Place.where(status: "live").limit

  #   @places = ActiveSupport::JSON.decode(@places.to_json)
  #   # debugger
  # end

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
