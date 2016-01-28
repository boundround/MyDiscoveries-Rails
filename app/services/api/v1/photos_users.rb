module API
	module V1
		class PhotosUsers < Base
			
			self.friendly_id = false
			use_resource!
			paginate per_page: 10

			helpers do

				def photos_user_params
					posts.require(:photos_user).permit(:photo_id, :user_id)
				end

			end

			resources :photos_users do

				desc "POST new photos user"
				post do
					photos_user = context_resource
					if photos_user.save
						message "Photos user created."
					else
						standard_validation_error(photos_user)
					end
				end

				desc "DELETE photos user"
				delete ':id' do
					photos_user = context_resource
					photos_user.destroy ? message("Photos user is destroyed." ) : standard_permission_denied_error
				end

			end

		end
	end
end