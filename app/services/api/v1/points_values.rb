module API
	module V1
		class PointsValues < Base
			
			self.friendly_id = false
			use_resource!
			paginate per_page: 10

			helpers do

				def points_value_params
					posts.require(:points_value).permit(:asset_type, :value, :_destroy)
				end

			end

			resources :points_values do

				desc "GET all points values with pagination."
				get do
					presenter paginate(PointsValue.all, per_page: params[:per_page], page: params[:page])
				end

				desc "GET points value id"
				get ':id' do
					points_value
				end

				desc "POST new points value"
				post do
					points_value = context_resource

					if points_value.save
						message "Points value created."
					else
						standard_validation_error(points_value)
					end
				end

				desc "PUT edit on points value"
				put ':id' do
					points_value = context_resource
					if points_value.update points_value_params
						message "Points value updated."
					else
						standard_validation_error(points_value)
					end
				end

				desc "DELETE points value"
				delete ':id' do
					points_value = context_resource
					points_value.destroy ? message("Points value is destroyed." ) : standard_permission_denied_error
				end

			end

		end
	end
end