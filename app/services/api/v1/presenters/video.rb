module API
	module V1
		module Presenters
			class Video < Grape::Entity

				expose :id
				expose :vimeo_id
				expose :area, using: 'API::V1::Presenters::Area'
				expose :transcript, documentation: {type: 'Text', desc: 'Video transcript'} 
				expose :youtube_id 
				expose :title, documentation: {type: 'String', desc: 'Video title'}
				expose :hero, documentation: {type: 'Boolean', desc: 'Video hero'}
				expose :description, documentation: {type: 'Text', desc: 'Video description'}
				expose :place, using: 'API::V1::Presenters::Place' 
				expose :priority, documentation: {type: 'Integer', desc: 'Video priority'}
				expose :vimeo_thumbnail, documentation: {type: 'String', desc: 'Video vimeo thumbnail'}
				expose :status, documentation: {type: 'String', desc: 'Video status'}
				expose :country_include, documentation: {type: 'Boolean', desc: 'Video country include'}
				expose :customer_approved, documentation: {type: 'Boolean', desc: 'Video customer approved'}
				expose :customer_review, documentation: {type: 'Boolean', desc: 'Video customer review'}
				expose :approved_at
				
				expose :created_at
				expose :updated_at

			end
		end
	end
end