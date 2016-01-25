module Responder
	extend ActiveSupport::Concern

	included do
		helpers do

			def message message=nil, options={ status: "ok"}
				{message: message, status: options[:status]}
			end

			def standard_validation_error object = nil, options = { error: "Unprocessable entity" }
				if object.kind_of?(ActiveRecord::Base) || options[:detail].is_a?(Hash)
					options[:detail] = object.errors if options[:detail].is_a?(Hash)
					error!(options, 422)
				end
			end

			def standar_success_message options = {}

			end

			def standard_permission_denied_error
				error!({ error: "Unauthorized!"}, 403)
			end

		end
	end
end
