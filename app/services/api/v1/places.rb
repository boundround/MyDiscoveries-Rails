module API
	module V1
		class Places < Base

			helpers do
				def place_params
					posts.require(:place).permit(:code, :identifier, :display_name, :description, :show_on_school_safari, :school_safari_description, :booking_url, :display_address, :subscription_level,
		                                    :latitude, :longitude, :logo, :phone_number, :website, :booking_url, :icon, :map_icon, :published_at, :unpublished_at,
		                                    :street_number, :route, :sublocality, :locality, :state, :post_code, :created_by, :user_created, :hero_image, :remote_hero_image_url, :crop_x, :crop_y, :crop_h, :crop_w,
		                                    :customer_approved, :customer_review, :approved_at, :country_id, :bound_round_place_id,
		                                    :passport_icon, :address, :area_id, :tag_list, :location_list, :activity_list, :place_id, :status,
		                                    photos_attributes: [:id, :place_id, :hero, :title, :path, :caption, :alt_tag, :credit, :caption_source, :priority, :status, :customer_approved, :customer_review, :approved_at, :country_include, :_destroy],
		                                    videos_attributes: [:id, :vimeo_id, :youtube_id, :transcript, :hero, :priority, :title, :description, :place_id, :area_id, :status, :country_include, :customer_approved, :customer_review, :approved_at, :_destroy],
		                                    games_attributes: [:id, :url, :area_id, :place_id, :priority, :game_type, :status, :customer_approved, :customer_review, :approved_at, :_destroy],
		                                    fun_facts_attributes: [:id, :content, :reference, :priority, :area_id, :place_id, :status, :hero_photo, :photo_credit, :customer_approved, :customer_review, :approved_at, :country_include, :_destroy],
		                                    discounts_attributes: [:id, :description, :place_id, :area_id, :status, :customer_approved, :customer_review, :approved_at, :country_include, :_destroy],
		                                    user_photos_attributes: [:id, :title, :path, :caption, :hero, :story_id, :priority, :user_id, :place_id, :area_id, :status, :google_place_id, :google_place_name, :instagram_id, :remote_path_url, :_destroy],
		                                    category_ids: [])
				end
			end

			resources :places do

				desc "GET all places."
				get do
					Place.joins(:area).select(:display_name, :id, :place_id, :subscription_level, :status, :updated_at, "areas.display_name AS area_name")
				end

				desc "POST new place"
				post do
					place = Place.new(place_params)
			    if place.identifier == ''
			      place.identifier = place.display_name.gsub(/\W/, '').downcase
			    end
			    if place.save
			     message "Place #{place.display_name} is created."
			    else
			    	standard_validation_error(place)
			    end
				end

				desc "GET existing place."
				get ':id' do
					place = Place.friendly.find params[:id]
				end

				desc "PUT update existing place."
				put ':id' do
					place = Place.friendly.find(params[:id])

			    if place.update(place_params)

			      place.photos.each do |photo|
			        photo.add_or_remove_from_country(place.country)
			      end

			      place.videos.each do |video|
			        video.add_or_remove_from_country(place.country)
			      end

			      place.fun_facts.each do |fun_fact|
			        fun_fact.add_or_remove_from_country(place.country)
			      end

			      place.discounts.each do |discount|
			        discount.add_or_remove_from_country(place.country)
			      end
			        {status: 201, message: 'Ok'}

			    else
			      standard_validation_error(place)
			    end
				end

				desc "DELETE existing place."
				delete ':id' do
					place = Place.friendly.find params[:id]
					place.destroy ? message("#{place.display_name} is destroyed." ) : standard_permission_denied_error
				end

			end

		end
	end
end
