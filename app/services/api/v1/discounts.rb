module API
	module V1
		class Discounts < Base

			self.friendly_id = false
			use_resource!

			helpers do
				def discount_params
					posts.require(:discount).permit(:description, :place_id, :discount_id, :status, :country_include, :customer_approved, :customer_review, :approved_at, :_destroy)
				end
			end

			resources :discounts do

				desc "POST new discount"
				post do
					discount = context_resource
			    discount.save ? message("Discount added.") : standard_validation_error(discount)
				end

				desc "PUT update existing discount"
				put ':id' do
					discount = context_resource
					if discount.update discount_params
						discount.save
						message "Discount is updated."
					else
						standard_validation_error(discount)
					end
				end

				desc "DELETE an discount"
				delete ':id' do
					discount = context_resource
					place.destroy ? message("#{discount.display_name} is destroyed." ) : standard_permission_denied_error
				end

			end

		end
	end
end
