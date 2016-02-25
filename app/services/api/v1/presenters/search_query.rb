module API
	module V1
		module Presenters
			class SearchQuery < Grape::Entity

				expose :id
				expose :term, documentation: {type: 'String', desc: 'Search Query term'} 
				expose :source, documentation: {type: 'String', desc: 'Search Query source'} 
				expose :city, documentation: {type: 'String', desc: 'Search Query city'} 
				expose :country, documentation: {type: 'String', desc: 'Search Query country'} 

				expose :created_at
				expose :updated_at
				
			end
		end
	end
end