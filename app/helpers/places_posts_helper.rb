module PlacesPostsHelper
  def array_places_posts_ids(places_posts)
    place_ids = []
    places_posts.each do |places_post|
      if !places_post.place_id.blank?
        place = Place.find(places_post.place_id)
        place_ids.push({place_id: place.id, place_name: place.display_name})
      end
    end
    place_ids.to_json
  end
end
