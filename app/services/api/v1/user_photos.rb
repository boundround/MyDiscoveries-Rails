module API
	module V1
		class UserPhotos < Base
			
			self.friendly_id = false
			use_resource!
			paginate per_page: 10

			helpers do

				def user_photo_params
					posts.require(:user_photo).permit(:title, :path, :caption, :hero, :story_id, :user_id,
                                        :place_id, :area_id, :status, :google_place_id,
                                        :google_place_name, :instagram_id, :remote_path_url, :_destroy)
				end

			end

			resources :user_photos do

				desc "GET all User Photos with pagination."
				get do
					presenter paginate(Photo.all, per_page: params[:per_page], page: params[:page])
				end

				desc "GET User Photo id"
				get ':id' do
					user_photo
				end

				desc "POST new User Photo"
				post do
					user_photo = context_resource

					if user_photo.save
						if !user_photo.story
			        NewUserPhoto.notification(user_photo).deliver
			      end
						message "User Photo created."
					else
						standard_validation_error(user_photo)
					end
				end

				desc "PUT edit on User Photo"
				put ':id' do
					user_photo = context_resource
					if params[:add_country]
			      user_photo.country_id = user_photo.place.country_id
			    else
			      user_photo.country_id = nil
			    end
					if user_photo.update user_photo_params
						message "User Photo updated."
					else
						standard_validation_error(user_photo)
					end
				end

				desc "DELETE User Photo"
				delete ':id' do
					user_photo = context_resource
					user_photo.destroy ? message("User Photo is destroyed." ) : standard_permission_denied_error
				end

				desc "POST new Profile Create"
				post :profile_create do
			    user_photo = context_resource
			    place = Place.find_by(place_id: user_photo.google_place_id)
			    if place && place.place_id != ""
			      user_photo.place = place
			    end

			    if user_photo.save
			      NewUserPhoto.notification(user_photo).deliver
			      message "Thanks for the photo. We'll let you know when others can see it too!"
			    else
			      message "We're sorry. There was an error uploading your photo."
			    end
			  end

			end

		end
	end
end