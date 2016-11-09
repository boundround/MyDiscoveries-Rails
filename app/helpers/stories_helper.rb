module StoriesHelper
  def array_places_stories_ids(places_stories)
    place_ids = []
    places_stories.each do |places_story|
      if !places_story.place_id.blank?
        place = Place.find(places_story.place_id)
        place_ids.push({place_id: place.id, place_name: place.display_name})
      end
    end
    place_ids.to_json
  end

  def array_attractions_stories_ids(attractions_stories)
    attraction_ids = []
    attractions_stories.each do |attractions_story|
      if !attractions_story.attraction_id.blank?
        attraction = Attraction.find(attractions_story.attraction_id)
        attraction_ids.push({attraction_id: attraction.id, attraction_name: attraction.display_name})
      end
    end
    
    attraction_ids.to_json
  end

  def array_countries_stories_ids(countries_stories)
    country_ids = []
    countries_stories.each do |countries_story|
      if !countries_story.country_id.blank?
        country = Country.find(countries_story.country_id)
        country_ids.push({country_id: country.id, country_name: country.display_name})
      end
    end
    country_ids.to_json
  end
end
