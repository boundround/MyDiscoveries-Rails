module API
	module V1
		module Presenters
			class GamesUser < Grape::Entity

				expose :id
				expose :game, using: 'API::V1::Presenters::Game'

			end
		end
	end
end