module API
	module V1
		class VideosUsers < Base
			
			self.friendly_id = false
			use_resource!
			paginate per_page: 10

			helpers do

				def videos_user_params
					posts.require(:videos_user).permit(:video_id, :user_id)
				end

			end

			resources :videos_users do

				desc "POST new videos user"
				post do
					videos_user = context_resource

					if videos_user.save
						message "Videos user created."
					else
						standard_validation_error(videos_user)
					end
				end

				desc "DELETE Videos user"
				delete ':id' do
					videos_user = context_resource
					videos_user.destroy ? message("Videos user is destroyed." ) : standard_permission_denied_error
				end

			end

		end
	end
end