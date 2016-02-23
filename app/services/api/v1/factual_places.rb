module API
	module V1
		class FactualPlaces < Base

			helpers do
				def bug_post_params
      		posts.require(:bug_post).permit(:description, :user_id, :author, :screen_shot)
    		end
			end

			resources :factual_places do
				get :search do
			    term = params[:term]
			    lat = params[:lat]
			    lng = params[:lng]
			    factual = Factual.new(ENV["FACTUAL_KEY"], ENV["FACTUAL_SECRET"])
			    allowed_categories = [44, 50, 107, 108, 109, 110, 111, 112, 113, 114,
			                          115, 116, 117, 118, 119, 120, 121, 122, 147, 151,
			                          153, 154, 311, 319, 323, 325, 328, 331, 332, 344,
			                          371, 389, 390, 392, 394, 402, 403, 407, 413, 452]
			    factual.table("places").search(term).geo("$circle" => {"$center" => [lat, lng], "$meters" => 100}).filters("category_ids" => {"$includes_any" => allowed_categories}).rows
				end
			end

		end
	end
end