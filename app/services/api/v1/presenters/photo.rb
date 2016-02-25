module API
	module V1
		module Presenters
			class Photo < Grape::Entity

				expose :id
				expose :title, documentation: {type: 'String', desc: 'Photo title'} 
				expose :path, documentation: {type: 'String', desc: 'Photo path'}
				expose :alt_tag, documentation: {type: 'String', desc: 'Photo alt tag'}
				expose :credit, documentation: {type: 'String', desc: 'Photo credit'}
				expose :area, using: 'API::V1::Presenters::Area' 
				expose :place, using: 'API::V1::Presenters::Place' 
				expose :caption, documentation: {type: 'Text', desc: 'Photo caption'}
				expose :caption_source, documentation: {type: 'String', desc: 'Photo caption source'}
				expose :customer_approved, documentation: {type: 'Boolean', desc: 'Photo customer approve'}
				expose :customer_review, documentation: {type: 'Boolean', desc: 'Photo customer review'}
				expose :priority, documentation: {type: 'Integer', desc: 'Photo priority'}
				expose :hero, documentation: {type: 'Boolean', desc: 'Photo hero'}
				expose :status, documentation: {type: 'String', desc: 'Photo status'}
				expose :sound_sprite, documentation: {type: 'String', desc: 'Photo sound sprite'}
				expose :country_include, documentation: {type: 'Boolean', desc: 'Photo country include'}
				expose :approved_at

				expose :created_at
				expose :updated_at
				
			end
		end
	end
end
