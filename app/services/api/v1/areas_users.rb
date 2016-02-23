module API
	module V1
		class AreasUsers < Base

			helpers do
				def areas_user_params
					posts.require(:areas_user).permit(:area_id, :user_id)
				end
			end

			resources :areas_users do

				desc "Post new area user"
				post do
					areas_user = AreasUser.new(areas_user_params)
					areas_user.save ? message("Area user created.") : standard_validation_error(areas_user)
				end

				desc "DELETE areas' user"
				delete do
					areas_user = AreasUser.find_by(area_id: params.traverse("areas_user", "area_id"), user_id: params.traverse["areas_user", "user_id"])
					raise ActiveRecord::RecordNotFound if areas_user.nil?
					areas_user.destroy ? message("Record is destroyed." ) : standard_permission_denied_error
				end

			end

		end
	end
end