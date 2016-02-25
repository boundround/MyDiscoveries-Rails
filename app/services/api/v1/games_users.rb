module API
	module V1
		class GamesUsers < Base

			self.friendly_id = false
			use_resource!

			helpers do
				def games_user_params
      		posts.require(:games_user).permit(:game_id, :user_id)
    		end
			end

			resources :games_users do

				desc "POST new games user"
				post do
					games_user = context_resource
			    if games_user.save
			      message('Games user created.')
					else
						standard_validation_error(game)
					end
				end

				desc "DELETE games user"
				delete ':id' do
					games_user = GamesUser.find_by(game_id: params.traverse("games_user","game_id"), user_id: params.traverse("games_user", "user_id"))
					games_user.destroy ? message("games user is destroyed." ) : standard_permission_denied_error
				end

			end
		end
	end
end