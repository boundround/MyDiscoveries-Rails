module API
	module V1
		module Presenters
			class Place < Grape::Entity

				expose :id
				expose :description, documentation: {type: "Text", desc: "Place description"}
				expose :code, documentation: { type: "String", desc: "Place code" }
				expose :identifier, documentation: { type: "String", desc: "Place identifier" }
				expose :display_name, documentation: {type: "String", desc: "Place display name" }
				expose :subscription_level, documentation: {type: 'String'}
				expose :icon, documentation: {type: 'String', desc: 'Place icon url'}
				expose :map_icon, documentation: {type: 'String'}
				expose :passport_icon, documentation: {type: 'String'}
				expose :area, using: 'API::V1::Presenters::Area'
				expose :slug
				expose :latitude, documentation: {type: 'Float', desc: "Place latitude" }
				expose :longitude, documentation: {type: 'Float', desc: "Place longitude" }
				expose :address, documentation: {type: "String", desc: "Place address"}
				expose :opening_hours, documentation: {type: 'Text'}
				expose :phone_number, documentation: {type: 'String'}
				expose :website, documentation: {type: 'String'}
				expose :logo, documentation: {type: 'String', desc: 'Place logo url'}
				expose :url, documentation: {type: 'String'}
				expose :display_address, documentation: {type: 'String'}
				expose :booking_url, documentation: {type: 'String', desc: 'Place booking url'}
				expose :post_code, documentation: {type: 'String'}
				expose :street_number, documentation: {type: 'String'}
				expose :route,  documentation: {type: 'String'}
				expose :sublocality, documentation: {type: 'String'}
				expose :locality, documentation: {type: 'String'}
				expose :state, documentation: {type: 'String'}
				expose :place_id, documentation: {type: 'String'}
				expose :status
				expose :published_at
				expose :unpublished_at
				expose :user_created, documentation: {type: 'Boolean'}
				expose :created_by, documentation: {type: 'String'}
				expose :country, using: 'API::V1::Presenters::Country'
				expose :customer_review, documentation: {type: 'Boolean'}
				expose :customer_approved, documentation: {type: 'Boolean'}
				expose :approved_at
				expose :show_on_school_safari, documentation: {type: 'Boolean'}
				expose :school_safari_description, documentation: {type: 'Text'}
				expose :hero_image, documentation: {type: 'String', desc: 'Place hero image url'}
				expose :bound_round_place_id, documentation: {type: 'String'}

				expose :created_at
				expose :updated_at

			end
		end
	end
end