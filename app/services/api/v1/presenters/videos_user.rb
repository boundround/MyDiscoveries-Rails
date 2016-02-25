module API
	module V1
		module Presenters
			class VideosUser < Grape::Entity

				expose :id
				expose :video, using: 'API::V1::Presenters::Video'

			end
		end
	end
end
