json.items @stories do |story|
  json.id story.id
  json.title story.title
  json.excerpt story.teaser.gsub(/\R+/, ' ')
  json.author story.author_name
  json.created_at story.created_at
  json.updated_at story.updated_at
  json.body story.content_for_feed.gsub(/\R+/, ' ')
  json.link story.links
  json.places_ids story.places.map { |place| place.id }
  json.attractions_ids story.attractions.map { |attraction| attraction.id }
  json.countries_ids story.countries.map { |country| country.id }
  json.regions_ids story.regions.map { |region| region.id }
  json.photos story.story_images do |photo|
    json.path photo.file, :url
  end
  json.featured_photo story.hero_image_url
  json.weather story.weather
	json.age_range story.age_range
	json.best_time_to_visit story.best_time_to_visit
  json.categories story.subcategory
end