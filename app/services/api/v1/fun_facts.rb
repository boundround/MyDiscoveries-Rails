module API
	module V1
		class FunFacts < Base

			self.friendly_id = false
			use_resource!
			helpers do
				def fun_fact_params
      		posts.require(:fun_fact).permit(:content, :reference, :priority, :area_id, :place_id, :hero_photo, :status, :photo_credit,
                                        :customer_approved, :customer_review, :approved_at, :country_include, :_destroy)
    		end
			end

			resources :fun_facts do

				desc "GET all fun facts"
				get do
					FunFact.where("length(content) > 140").order(:id)
				end

				desc "POST new fun fact"
				post do
					fun_fact = context_resource
			    if params[:country_id]
			      fun_fact.countries << Country.friendly.find(params[:country_id])
			    end
					if fun_fact.save
						message "fun fact created."
					else
						standard_validation_error(fun_fact)
					end
				end

				desc "PUT edit on fun fact"
				put ':id' do
					fun_fact = context_resource
					if fun_fact.update fun_fact_params
						fun_fact.save
						message "fun fact updated."
					else
						standard_validation_error(fun_fact)
					end
				end

				desc "DELETE fun fact"
				delete ':id' do
					fun_fact = context_resource
					fun_fact.destroy ? message("fun fact is destroyed." ) : standard_permission_denied_error
				end

			end
		end
	end
end