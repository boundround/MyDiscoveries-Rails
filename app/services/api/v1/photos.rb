module API
	module V1
		class Photos < Base
			
			self.friendly_id = false
			use_resource!
			paginate per_page: 10

			helpers do

				def photo_params
					posts.require(:photo).permit(:title, :path, :alt_tag, :credit, :area_id, :place_id, :caption, :caption_source,
                                    :customer_approved, :customer_review, :approved_at, :priority, :hero, :status, :country_include, :_destroy)
				end

			end

			resources :photos do

				desc "GET all Photos with pagination."
				get do
					presenter paginate(Photo.all, per_page: params[:per_page], page: params[:page])
				end

				desc "GET Photo id"
				get ':id' do
					photo
				end

				desc "POST new Photo"
				post do
					photo = context_resource
					if params[:country_id]
			      photo.countries << Country.friendly.find(params[:country_id])
			    end

					if photo.save
						message "Photo created."
					else
						standard_validation_error(photo)
					end
				end

				desc "PUT edit on Photo"
				put ':id' do
					photo = context_resource
					if photo.update photo_params
						message "Photo updated."
					else
						standard_validation_error(photo)
					end
				end

				desc "DELETE Photo"
				delete ':id' do
					photo = context_resource
					photo.destroy ? message("Photo is destroyed." ) : standard_permission_denied_error
				end

			end

		end
	end
end