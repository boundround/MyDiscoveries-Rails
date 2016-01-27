module API
	module V1
		module Presenters
			class FamousFace < Grape::Entity

				expose :id
				expose :name, documentation: {:type => 'String'}
				expose :description, documentation: {type: "String", desc: "Famouse face description"}
				expose :photo, documentation: {type: "String", desc: "Famous face photo url"}
				expose :photo_credit, documentation: {type: "String", desc: "Famous face photo credit"}
				expose :status

				expose :created_at
				expose :updated_at

			end
		end
	end
end