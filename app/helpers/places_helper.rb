module PlacesHelper
  def pick_a_place_photo_url(place)
    place.photos[rand(place.photos.count-1)].path
  end
  
end
