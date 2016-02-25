module API
	module V1
		module Presenters
			class UserPhotosUser < Grape::Entity

				expose :id
				expose :user_photo, using: 'API::V1::Presenters::UserPhoto'

			end
		end
	end
end
