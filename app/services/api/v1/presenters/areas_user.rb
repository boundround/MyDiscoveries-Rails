module API
	module V1
		module Presenters
			class AreasUser < Grape::Entity

				expose :user, using: 'API::V1::Presenters::User'
				expose :area, using: 'API::V1::Presenters::Area'

			end
		end
	end
end