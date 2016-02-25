module API
	module V1
		class ReviewsUsers < Base
			
			self.friendly_id = false
			use_resource!
			paginate per_page: 10

			helpers do

				def reviews_user_params
					posts.require(:reviews_user).permit(:review_id, :user_id)
				end

			end

			resources :reviews_users do

				desc "POST new reviews user"
				post do
					reviews_user = context_resource

					if reviews_user.save
						message "Reviews user created."
					else
						standard_validation_error(reviews_user)
					end
				end

				desc "DELETE Reviews user user"
				delete ':id' do
					reviews_user = context_resource
					reviews_user.destroy ? message("Reviews user is destroyed." ) : standard_permission_denied_error
				end

			end

		end
	end
end