module API
	module V1
		class StoriesUsers < Base
			
			self.friendly_id = false
			use_resource!
			paginate per_page: 10

			helpers do

				def stories_user_params
					posts.require(:stories_user).permit(:story_id, :user_id)
				end

			end

			resources :stories_users do

				desc "POST new stories user"
				post do
					stories_user = context_resource

					if stories_user.save
						message "stories user created."
					else
						standard_validation_error(stories_user)
					end
				end

				desc "DELETE stories user"
				delete ':id' do
					stories_user = context_resource
					stories_user.destroy ? message("Stories user is destroyed." ) : standard_permission_denied_error
				end

			end

		end
	end
end