module API
	module V1
		class SearchQueries < Base
			
			self.friendly_id = false
			use_resource!

			helpers do

				def search_query_params
					posts.require(:search_query).permit(:term, :source, :city, :country)
				end

			end

			resources :search_queries do

				desc "POST new Search query"
				post do
					search_query = context_resource

					if search_query.save
						message "Search query created."
					else
						standard_validation_error(search_query)
					end
				end

			end

		end
	end
end