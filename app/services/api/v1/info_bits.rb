module API
	module V1
		class InfoBits < Base
			
			self.friendly_id = false
			use_resource!
			paginate per_page: 10

			helpers do

				def info_bit_params
					posts.require(:info_bit).permit(:title, :description, :photo, :photo_credit, :status, :_destroy)
				end

			end

			resources :info_bits do

				desc "GET all info bits with pagination."
				get do
					presenter paginate(InfoBit.all, per_page: params[:per_page], page: params[:page])
				end

				desc "GET info bit with id"
				get ':id' do
					info_bit
				end

				desc "POST new info bit"
				post do
					info_bit = context_resource
					if info_bit.save
						message "Info Bit created."
					else
						standard_validation_error(info_bit)
					end
				end

				desc "PUT edit on info bit"
				put ':id' do
					info_bit = context_resource
					if info_bit.update info_bit_params
						message "Info bit updated."
					else
						standard_validation_error(info_bit)
					end
				end

				desc "DELETE info bit"
				delete ':id' do
					info_bit = context_resource
					info_bit.destroy ? message("Info bit is destroyed." ) : standard_permission_denied_error
				end

			end

		end
	end
end