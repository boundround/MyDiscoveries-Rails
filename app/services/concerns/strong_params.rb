require 'action_controller/metal/strong_parameters'

module StrongParams
	extend ActiveSupport::Concern

	included do 
		helpers do

			def posts
				@strong_parameter_object ||= ActionController::Parameters.new(params)
				@strong_parameter_object
			end

		end
	end
end
