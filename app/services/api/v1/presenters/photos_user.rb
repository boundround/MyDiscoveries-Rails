module API
	module V1
		module Presenters
			class PhotosUser < Grape::Entity

				expose :id
				expose :photo, using: 'API::V1::Presenters::Photo'

			end
		end
	end
end