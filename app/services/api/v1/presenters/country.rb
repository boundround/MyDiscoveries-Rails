module API
	module V1
		module Presenters
			class Country < Grape::Entity

				expose :id
				expose :display_name, documentation: {type: 'String'}
				expose :country_code, documentation: {type: 'String'}
				expose :description, documentation: {type: 'Text'}
				expose :capital_city
				expose :capital_city_description
				expose :currency_code
				expose :official_language
				expose :tallest_mountain
				expose :tallest_mountain_height, documentation: {type: 'Integer'}
				expose :longest_river
				expose :longest_river_length, documentation: {type: 'Integer'}
				expose :slug
				expose :published_status, documentation: {type: 'String'}
				expose :hero_photo, documentation: {type: 'String', desc: 'Country hero photo url'}
				expose :short_name
				expose :long_name
				expose :photo_credit
				expose :google_place_id
				expose :latitude, documentation: {type: 'Float', desc: "Country latitude" }
				expose :longitude, documentation: {type: 'Float', desc: "Country longitude" }
				expose :address, documentation: {type: "String", desc: "Country address"}

				expose :created_at
				expose :updated_at

			end
		end
	end
end