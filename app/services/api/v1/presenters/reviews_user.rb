module API
	module V1
		module Presenters
			class ReviewsUser < Grape::Entity

				expose :id
				expose :review_id, documentation: {type: 'Integer', desc: 'Review User review id'} #using: 'API::V1::Presenters::Review'

			end
		end
	end
end