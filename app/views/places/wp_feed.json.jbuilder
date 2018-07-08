json.places @places do |place|
	json.id place.id
	json.name place.display_name
	json.description place.description.gsub(/\R+/, ' ')
	json.latitude place.latitude
	json.longitude place.longitude
	json.map_zoom_level place.zoom_level
	json.photos place.photos.each do |photo|
		json.id photo.id
		json.created_at photo.created_at
		json.path photo.path, :url, :small, :medium, :large
		json.credit photo.credit
		json.caption photo.caption
	end
	json.videos place.videos do |video|
		json.id video.id
		json.vimeo_id video.vimeo_id
		json.thumbnail video.vimeo_thumbnail
		json.title video.title
		json.description video.description
		json.youtube_id video.youtube_id
	end
	json.fun_facts place.fun_facts do |ff|
		json.id ff.id
		json.content ff.content
		json.photo ff.hero_photo_url
		json.photo_credit ff.photo_credit
	end
	json.tab_infos place.tab_infos do |ti|
		json.id ti.id
		json.title ti.title.upcase
		json.description ti.description.gsub(/\R+/, ' ')
		json.photo ti.image
		json.photo_credit ti.credit
	end
	json.stories_ids place.stories.map { |story| story.id }.uniq
	json.regions_ids place.regions.map { |region| region.id }.uniq
	json.featured_photo place.photos.find { |photo| photo.hero == true }.path_url(:large) rescue ''
	json.created_at place.created_at
	json.updated_at place.updated_at
	json.link place.links
	json.google_place_id place.place_id
	json.parent place.parent_for_wp_feed
end