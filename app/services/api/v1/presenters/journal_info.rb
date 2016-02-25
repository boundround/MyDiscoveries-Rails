module API
	module V1
		module Presenters
			class JournalInfo < Grape::Entity

				expose :id
				expose :place, using: 'API::V1::Presenters::Place'

				expose :created_at
				expose :updated_at
				
			end
		end
	end
end