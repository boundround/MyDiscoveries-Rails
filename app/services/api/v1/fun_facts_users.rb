module API
	module V1
		class FunFactsUsers < Base

			self.friendly_id = false
			use_resource!

			helpers do
				def fun_facts_user_params
      		posts.require(:fun_facts_user).permit(:fun_fact_id, :user_id)
    		end
			end

			resources :fun_facts_users do

				desc "POST new fun facts user"
				post do
					fun_facts_user = context_resource
			    if fun_facts_user.save
			      message('Fun facts user created.')
					else
						standard_validation_error(fun_fact)
					end
				end

				desc "DELETE fun facts user"
				delete ':id' do
					fun_facts_user = FunFactsUser.find_by(fun_fact_id: params.traverse("fun_facts_user","fun_fact_id"), user_id: params.traverse("fun_facts_user", "user_id"))
					fun_facts_user.destroy ? message("fun facts user is destroyed." ) : standard_permission_denied_error
				end

			end
		end
	end
end