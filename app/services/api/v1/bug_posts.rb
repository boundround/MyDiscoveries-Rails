module API
	module V1
		class BugPosts < Base

			use_resource!
			helpers do
				def bug_post_params
      		posts.require(:bug_post).permit(:description, :user_id, :author, :screen_shot)
    		end
			end

			resources :bug_posts do

				desc "GET all bug posts"
				get do
					BugPost.all
				end

				desc "POST new bug post"
				post do
					bug_post = context_resource
					if bug_post.save
						message "Bug post created."
					else
						standard_validation_error(bug_post)
					end
				end

				desc "GET existing bug post"
				get ':id' do
					bug_post
				end

				desc "PUT edit on bug post"
				put ':id' do
					bug_post = context_resource
					if bug_post.update bug_post_params
						message "Bug post updated."
					else
						standard_validation_error(bug_post)
					end
				end

				desc "DELETE bug post"
				delete ':id' do
					bug_post = context_resource
					bug_post.destroy ? message("Bug post is destroyed." ) : standard_permission_denied_error
				end

			end
		end
	end
end