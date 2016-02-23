module API
	module V1
		class Games < Base

			self.includes_on_finder = [place: [:area, :photos]]
			self.friendly_id = false
			use_resource!
			paginate per_page: 10

			helpers do

				def game_params
					posts.require(:game).permit(:url, :area_id, :place_id, :priority, :game_type, :status, :customer_approved, :customer_review, :approved_at, :_destroy)
				end

			end

			resources :games do

				desc "GET all games with pagination."
				get do
					presenter paginate(Game.includes(:place => [:area, :photos]).order('areas.display_name ASC, places.display_name ASC'), per_page: params[:per_page], page: params[:page])
				end

				desc "POST new game."
				post do
					game = context_resource
					if game.save
						game.add_instructions
						game.save
						message "game created."
					else
						standard_validation_error game
					end
				end

				desc "GET game with id"
				get ':id' do
					game
				end

			end

		end
	end
end