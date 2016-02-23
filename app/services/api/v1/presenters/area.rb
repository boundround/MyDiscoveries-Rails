module API
	module V1
		module Presenters
			class Area < Grape::Entity

				expose :id
				expose :code, documentation: { type: "String", desc: "Area code" }
				expose :identifier, documentation: { type: "String", desc: "Area identifier" }
				expose :display_name, documentation: {type: "String", desc: "Area display name" }
				expose :short_intro, documentation: {type: "String", desc: "Short description" }
				expose :description, documentation: {type: "Text", desc: "Area description" }
				expose :latitude, documentation: {type: 'Float', desc: "Area latitude" }
				expose :longitude, documentation: {type: 'Float', desc: "Area longitude" }
				expose :address, documentation: {type: "String", desc: "Area address"}
				expose :slug
				expose :published_status
				expose :view_latitude, documentation: {type: "Float", desc: "Area view latitude"}
				expose :view_longitude, documentation: {type: "Float", desc: "Area view longitude"}
				expose :view_height, documentation: {type: 'FLoat'}
				expose :view_heading, documentation: {type: 'FLoat'}
				expose :country, using: "API::V1::Presenters::Country"
				expose :google_place_id, documentation: {type: 'String', desc: "Google place id"}
				expose :created_at
				expose :updated_at

			end
		end
	end
end