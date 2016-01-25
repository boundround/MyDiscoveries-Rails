module API
	class Base < Grape::API
		
    include StrongParams
    include Responder 

		prefix 'API'
		format 'json'
		
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

    rescue_from :all do |e|
      if Rails.env.development?
        raise e
      else
        error_response(message: "Internal server error", status: 500)
      end
    end

    mount API::V1::Base

    route :any, '*path' do
      error!({ error:  'Not Found',
               detail: "No such route '#{request.path}'",
               status: '404' },
             404)
    end

	end
end