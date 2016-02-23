module API
	module V1
		class States < Base

			self.model_resource = 'Country'
			use_resource!
			helpers do

				def country_params
					posts.require(:country).permit(:display_name, :country_code, :description, :capital_city, :short_name, :long_name, :address,
                      :capital_city_description, :currency_code, :official_language, :tallest_mountain, :latitude, :longitude, :google_place_id,
                      :tallest_mountain_height, :longest_river, :longest_river_length, :published_status, :hero_photo, :photo_credit,
                      photos_attributes: [:id, :title, :path, :caption, :alt_tag, :credit, :caption_source, :priority, :status, :country_include, :_destroy],
                      videos_attributes: [:id, :vimeo_id, :priority, :status, :country_include, :_destroy],
                      fun_facts_attributes: [:id, :content, :reference, :priority, :hero_photo, :photo_credit, :status, :country_include, :_destroy],
                      famous_faces_attributes: [:id, :name, :description, :photo, :photo_credit, :status, :_destroy],
                      info_bits_attributes: [:id, :title, :description, :photo, :photo_credit, :status, :_destroy])
				end

			end

			resources :countries do

				desc "GET all countries"
				get do
					presenter Country.all
				end

				desc "POST new country"
				post do
					country = context_resource
					country.save ? message("Country is created.") : standard_validation_error(country)
				end

				desc "GET existing country"
				get ':id' do
					presenter country
				end

				desc "PUT edit on existing country"
				put ':id' do
					country = context_resource
					country.update(country_params) ? message("Country is updated.") : standard_validation_error(country)
				end

				desc "DELETE country"
				delete ':id' do
					country = context_resource
					country.destroy ? message("Country is destroyed." ) : standard_permission_denied_error
				end

			end

		end
	end
end