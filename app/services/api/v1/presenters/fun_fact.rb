module API
	module V1
		module Presenters
			class FunFact < Grape::Entity

				expose :id
				expose :content, documentation: {type: "Text", desc: "Fun fact content"}
				expose :reference,  documentation: {type: 'String'}
				expose :area, using: 'API::V1::Presenters::Area'
				expose :priority, documentation: {type: 'Integer', desc: "Fun fact priority"}
				expose :place, using: 'API::V1::Presenters::Place'
				expose :hero_photo, documentation: {type: 'String', desc: 'Fun fact hero photo url'}
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