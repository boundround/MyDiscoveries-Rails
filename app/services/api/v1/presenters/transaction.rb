module API
	module V1
		module Presenters
			class Transaction < Grape::Entity

				expose :id
				expose :asset_type, documentation: {type: 'String', desc: 'Transaction asset type'} 
				expose :asset_id, documentation: {type: 'Integer', desc: 'Transaction asset id'} 
				expose :comments, documentation: {type: 'Text', desc: 'Transaction comment'} 
				expose :user_id, documentation: {type: 'Integer', desc: 'Transaction user id'}
				expose :points, documentation: {type: 'Integer', desc: 'Transaction point'} 

				expose :created_at
				expose :updated_at
				
			end
		end
	end
end