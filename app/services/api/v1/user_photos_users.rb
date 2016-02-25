module API
	module V1
		class UserPhotosUsers < Base
			
			self.friendly_id = false
			use_resource!
			paginate per_page: 10

			helpers do

				def user_photos_user_params
					posts.require(:user_photos_user).permit(:user_photo_id, :user_id)
				end

			end

			resources :user_photos_users do

				desc "POST new user photos user"
				post do
					user_photos_user = context_resource

					if user_photos_user.save
						message "User photos user created."
					else
						standard_validation_error(user_photos_user)
					end
				end

				desc "DELETE User photos user"
				delete ':id' do
					user_photos_user = context_resource
					user_photos_user.destroy ? message("User photos user is destroyed." ) : standard_permission_denied_error
				end

			end

		end
	end
end