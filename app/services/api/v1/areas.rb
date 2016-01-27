module API
	module V1
		class Areas < Base

			self.includes_on_finder = [:videos, :games, :photos, :discounts, :fun_facts, places: [:photos, :games, :videos, :categories]]
			use_resource!

			helpers do
				def area_params
					posts.require(:area).permit(:code, :identifier, :display_name, :short_intro, :description,
                                    :latitude, :longitude, :address, :published_status, :view_latitude, :view_longitude,
                                    :view_height, :view_heading, :google_place_id, :country_id,
                                    photos_attributes: [:id, :area_id, :title, :path, :caption, :alt_tag, :credit, :caption_source, :priority, :status, :country_include, :_destroy],
                                    videos_attributes: [:id, :vimeo_id, :priority, :place_id, :area_id, :status, :country_include, :_destroy],
                                    games_attributes: [:id, :url, :area_id, :place_id, :priority, :game_type, :status, :_destroy],
                                    fun_facts_attributes: [:id, :content, :reference, :priority, :area_id, :place_id, :status, :hero_photo, :photo_credit, :country_include, :_destroy],
                                    discounts_attributes: [:id, :description, :place_id, :area_id, :status, :country_include, :_destroy])
				end
			end

			resources :areas do

				desc "GET all areas"
				get do
					presenter Area.all
				end

				desc "POST new area"
				post do
					area = context_resource
			    area.save ? message("Area created.") : standard_validation_error(area)
				end

				desc "GET area with id"
				get ':id' do
					presenter area
				end

				desc "PUT update existing area"
				put ':id' do
					area = context_resource
					if area.update area_params
						area.photos.each do |photo|
			        photo.add_or_remove_from_country(area.country)
			      end

			      area.videos.each do |video|
			        video.add_or_remove_from_country(area.country)
			      end

			      area.fun_facts.each do |fun_fact|
			        fun_fact.add_or_remove_from_country(area.country)
			      end

			      area.discounts.each do |discount|
			        discount.add_or_remove_from_country(area.country)
			      end

						message "Area #{area.display_name} is updated."
					else
						standard_validation_error(area)
					end
				end

				desc "DELETE an area"
				delete ':id' do
					area = context_resource
					place.destroy ? message("#{area.display_name} is destroyed." ) : standard_permission_denied_error
				end

			end

		end
	end
end
