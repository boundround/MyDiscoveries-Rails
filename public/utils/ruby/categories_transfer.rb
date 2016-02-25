Place.all.each do |place|

  place.places_secondary_categories.each do |cat|
    PlacesSubcategory.create(place_id: place.id, subcategory_id: cat.secondary_category_id)
  end

  place.duration_categories_places.each do |cat|
    case cat.duration_category_id
    when 1
      PlacesSubcategory.create(place_id: place.id, subcategory_id: 33)
    when 2
      PlacesSubcategory.create(place_id: place.id, subcategory_id: 34)
    when 3
      PlacesSubcategory.create(place_id: place.id, subcategory_id: 35)
    else
    end
  end

  place.best_time_to_visit_categories_places.each do |cat|
    case cat.best_time_to_visit_category_id
    when 1
      PlacesSubcategory.create(place_id: place.id, subcategory_id: 36)
    when 2
      PlacesSubcategory.create(place_id: place.id, subcategory_id: 37)
    when 3
      PlacesSubcategory.create(place_id: place.id, subcategory_id: 38)
    when 4
      PlacesSubcategory.create(place_id: place.id, subcategory_id: 39)
    else
    end
  end

  place.places_price_categories.each do |cat|
    case cat.price_category_id
    when 1
      PlacesSubcategory.create(place_id: place.id, subcategory_id: 44)
    when 2
      PlacesSubcategory.create(place_id: place.id, subcategory_id: 45)
    when 3
      PlacesSubcategory.create(place_id: place.id, subcategory_id: 46)
    when 4
      PlacesSubcategory.create(place_id: place.id, subcategory_id: 47)
    else
    end
  end

  place.places_weather_categories.each do |cat|
    case cat.weather_category_id
    when 1
      PlacesSubcategory.create(place_id: place.id, subcategory_id: 51)
    when 2
      PlacesSubcategory.create(place_id: place.id, subcategory_id: 52)
    when 3
      PlacesSubcategory.create(place_id: place.id, subcategory_id: 53)
    else
    end
  end

  place.accessibility_categories_places.each do |cat|
    case cat.accessibility_category_id
    when 1
      PlacesSubcategory.create(place_id: place.id, subcategory_id: 40)
    when 2
      PlacesSubcategory.create(place_id: place.id, subcategory_id: 41)
    when 3
      PlacesSubcategory.create(place_id: place.id, subcategory_id: 42)
    when 4
      PlacesSubcategory.create(place_id: place.id, subcategory_id: 43)
    else
    end
  end
end
