module API
	module V1
		module Presenters
			class StoriesUser < Grape::Entity

				expose :id
				expose :story_id, documentation: {type: 'Integer', desc: 'Stories User story id'} #using: 'API::V1::Presenters::Review'

			end
		end
	end
end
