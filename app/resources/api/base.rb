module API
	class Base < Grape::API
		
		prefix 'API'
		format 'json'
		version 'v1', using: :path
		
		helpers do
      def logger
        Rails.logger
      end
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      error_response(message: e.message, status: 404)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      error_response(message: e.message, status: 422)
    end

    rescue_from ActionController::ParameterMissing do |e|
    	error_response(message: e.message, status: 422)
    end

		mount API::V1::Places

	end
end