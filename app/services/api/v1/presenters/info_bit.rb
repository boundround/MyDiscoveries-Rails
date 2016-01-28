module API
	module V1
		module Presenters
			class InfoBit < Grape::Entity

				expose :id
				expose :title, documentation: {type: 'String', desc: 'Info Bit title'} 
				expose :description, documentation: {type: 'Text', desc: 'Info Bit description'}
				expose :photo, documentation: {type: 'String', desc: 'Info Bit photo'}
				expose :photo_credit, documentation: {type: 'String', desc: 'Info Bit photo_credit'}
				expose :status, documentation: {type: 'String', desc: 'Info Bit status'}

				expose :created_at
				expose :updated_at
				
			end
		end
	end
end