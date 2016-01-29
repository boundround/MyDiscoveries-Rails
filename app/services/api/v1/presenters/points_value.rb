module API
	module V1
		module Presenters
			class PointsValue < Grape::Entity

				expose :id
				expose :asset_type, documentation: {type: 'String', desc: 'Photo asset type'}
				expose :value, documentation: {type: 'Integer', desc: 'Points Value value'}

				expose :created_at
				expose :updated_at
				
			end
		end
	end
end