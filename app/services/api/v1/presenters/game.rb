module API
	module V1
		module Presenters
			class Game < Grape::Entity

				expose :id
				expose :url, documentation: {type: 'String', desc: 'Game url'}
				expose :place, using: 'API::V1::Presenters::Place'
				expose :priority, documentation: {type: 'Integer', desc: 'Game priority'}
				expose :game_type, documentation: {type: 'String', desc: 'Game type'}
				expose :instructions, documentation: {type: 'String', desc: 'Game instructions'}
				expose :area, using: 'API::V1::Presenters::Area'
				expose :thumbnail, documentation: {type: 'String', desc: 'Game thumbnail url'}
				expose :status
				expose :customer_review, documentation: {type: 'Boolean'}
				expose :customer_approved, documentation: {type: 'Boolean'}
				expose :approved_at

				expose :created_at
				expose :updated_at

			end
		end
	end
end

