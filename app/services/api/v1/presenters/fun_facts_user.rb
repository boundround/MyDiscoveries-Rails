module API
	module V1
		module Presenters
			class FunFactsUser < Grape::Entity

				expose :id
				expose :fun_fact, using: 'API::V1::Presenters::FunFact'

			end
		end
	end
end