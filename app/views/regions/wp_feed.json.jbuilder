json.regions @regions do |region|
	json.id region.id
	json.name region.display_name
	json.description region.description.gsub(/\R+/, ' ')
	json.latitude region.latitude
	json.longitude region.longitude
	json.map_zoom_level region.zoom_level
	json.photos region.photos.each do |photo|
		json.id photo.id
		json.created_at photo.created_at
		json.path photo.path, :url, :small, :medium, :large
		json.credit photo.credit
		json.caption photo.caption
	end
	json.videos region.videos do |video|
		json.id video.id
		json.vimeo_id video.vimeo_id
		json.thumbnail video.vimeo_thumbnail
		json.title video.title
		json.description video.description
		json.youtube_id video.youtube_id
	end
	json.fun_facts region.fun_facts do |ff|
		json.id ff.id
		json.content ff.content.gsub(/\R+/, ' ')
		json.photo ff.hero_photo_url
		json.photo_credit ff.photo_credit
	end
	json.stories_ids region.stories.map { |story| story.id }.uniq
	json.places_ids region.places.map { |place| place.id }.uniq
	json.featured_photo region.photos.find { |photo| photo.hero == true }.path_url(:large) rescue ''
	json.created_at region.created_at
	json.updated_at region.updated_at
	json.link region.links
end