module API
	module V1
		module Presenters
			class Discount < Grape::Entity

				expose :id
				expose :description, documentation: {type: "Text", desc: "Discount post description"}
				expose :place, using: "API::V1::Presenters::Place"
				expose :priority, documentation: {type: "Integer", desc: "Discount priority"}
				expose :area, using: "API::V1::Presenters::Area"
				expose :status
				expose :country_include, documentation: {type: 'Boolean'}
				expose :customer_review, documentation: {type: 'Boolean'}
				expose :customer_approved, documentation: {type: 'Boolean'}
				expose :approved_at

				expose :created_at
				expose :updated_at

			end
		end
	end
end