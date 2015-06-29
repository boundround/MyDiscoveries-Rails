class SearchSuggestion < ActiveRecord::Base

  def self.terms_for(prefix)
    @places = Place.where(status: "live")
             .text_search(prefix).includes(:area)

    # @places = Place.where("display_name @@ :q or description @@ :q", q: params[:term])
    @areas = Area.where("display_name @@ :q", q: prefix)

    @places = ActiveSupport::JSON.decode(@places.to_json(include: :area))

    @areas = ActiveSupport::JSON.decode(@areas.to_json)

    both = @areas + @places

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
