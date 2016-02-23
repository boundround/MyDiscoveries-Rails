module API
	module V1
		class FamousFaces < Base

			use_resource!
			helpers do
				def famous_face_params
      		posts.require(:famous_face).permit(:name, :description, :photo, :photo_credit, :status, :_destroy)
    		end
			end

			resources :famous_faces do

				desc "GET all famous faces"
				get do
					presenter FamousFace.all
				end

				desc "POST new famous face"
				post do
					famous_face = context_resource
					if famous_face.save
						message "famous face created."
					else
						standard_validation_error(famous_face)
					end
				end

				desc "GET existing famous face"
				get ':id' do
					famous_face
				end

				desc "PUT edit on famous face"
				put ':id' do
					famous_face = context_resource
					if famous_face.update famous_face_params
						message "famous face updated."
					else
						standard_validation_error(famous_face)
					end
				end

				desc "DELETE famous face"
				delete ':id' do
					famous_face = context_resource
					famous_face.destroy ? message("famous face is destroyed." ) : standard_permission_denied_error
				end

			end
		end
	end
end