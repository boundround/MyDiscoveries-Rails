module API
	module V1
		module Presenters
			class Program < Grape::Entity

				expose :id
				expose :name, documentation: {type: 'String', desc: 'Program name	'}
				expose :description, documentation: {type: 'Text', desc: 'Program description'}
				expose :yearlevelnotes, documentation: {type: 'Text', desc: 'Program yearlevelnotes'}
				expose :cost, documentation: {type: 'String', desc: 'Program cost'}
			  expose :programpath, documentation: {type: 'String', desc: 'Program programpath'}
			  expose :heroimagepath, documentation: {type: 'String', desc: 'Program heroimagepath	'}
			  expose :duration, documentation: {type: 'String', desc: 'Program duration'}
			  expose :times, documentation: {type: 'Text', desc: 'Program times'}
			  expose :booknowpath, documentation: {type: 'String', desc: 'Program booknowpath'}
			  expose :contact, documentation: {type: 'String', desc: 'Program contact'}
				expose :place, using: 'API::V1::Presenters::Place'

				expose :created_at
				expose :updated_at
				
			end
		end
	end
end