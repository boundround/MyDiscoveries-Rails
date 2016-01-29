module API
	module V1
		module Presenters
			class UserPhoto < Grape::Entity

				expose :id
				expose :title, documentation: {type: 'String', desc: 'User Photo title'} 
				expose :path, documentation: {type: 'String', desc: 'User Photo path'} 
				expose :caption, documentation: {type: 'String', desc: 'User Photo caption'}
        expose :status, documentation: {type: 'String', desc: 'User Photo status'}
				expose :user_id,documentation: {type: 'Integer', desc: 'User Photo user id'}
				expose :story_id, documentation: {type: 'Integer', desc: 'User Photo story id'}
        expose :place, using: 'API::V1::Presenters::Place'
        expose :area, using: 'API::V1::Presenters::Area'
        expose :story_priority, documentation: {type: 'Integer', desc: 'User Photo story priority'}
        expose :google_place_id,documentation: {type: 'String', desc: 'User Photo google place id'}
				expose :priority, documentation: {type: 'Integer', desc: 'User Photo priority'}
				expose :user_notified, documentation: {type: 'Boolean', desc: 'User Photo user notified'}
				expose :user_notified_at
        expose :google_place_name, documentation: {type: 'String', desc: 'User Photo google place name'}
        expose :instagram_id, documentation: {type: 'String', desc: 'User Photo instagram id'}
				expose :hero, documentation: {type: 'Boolean', desc: 'User Photo hero'}
        expose :country, using: 'API::V1::Presenters::Country'

				expose :created_at
				expose :updated_at
				
			end
		end
	end
end