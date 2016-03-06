module SimilarPlacesHelper
  def array_similar_place_ids(similar_places)
    similar_ids = []
    similar_places.each do |similar_place|
      if !similar_place.similar_place_id.blank?
        place = Place.find(similar_place.similar_place_id)
        similar_ids.push({place_id: place.id, place_name: place.display_name})
      end
    end
    similar_ids.to_json
  end
end
