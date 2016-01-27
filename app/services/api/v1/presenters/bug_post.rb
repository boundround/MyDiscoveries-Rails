module API
	module V1
		module Presenters
			class BugPost < Grape::Entity

				expose :id
				expose :description, documentation: {type: "Text", desc: "Bug post description"}
				expose :screenshoot, documentation: {type: "String", desc: "Bug post screenshoot url"}
				expose :author, documentation: {type: "String", desc: "Bug post author"}

				expose :created_at
				expose :updated_at

			end
		end
	end
end