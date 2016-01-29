module API
	module V1
		class Transactions < Base
			
			self.friendly_id = false
			use_resource!
			paginate per_page: 10

			helpers do

				def transaction_params
					posts.require(:transaction).permit(:asset_type, :asset_id, :comments, :user_id, :points, :_destroy)
				end

			end

			resources :transactions do

				desc "GET all Transactions with pagination."
				get do
					presenter paginate(Transaction.all, per_page: params[:per_page], page: params[:page])
				end

				desc "GET Transaction id"
				get ':id' do
					transaction
				end

				desc "POST new Transaction"
				post do
					debugger
					transaction = context_resource

					if transaction.save
						message "Transaction created."
					else
						standard_validation_error(transaction)
					end
				end

				desc "PUT edit on Transaction"
				put ':id' do
					transaction = context_resource
					if transaction.update transaction_params
						message "Transaction updated."
					else
						standard_validation_error(transaction)
					end
				end

				desc "DELETE Transaction"
				delete ':id' do
					transaction = context_resource
					transaction.destroy ? message("Transaction is destroyed." ) : standard_permission_denied_error
				end

			end

		end
	end
end