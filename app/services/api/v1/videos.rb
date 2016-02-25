module API
	module V1
		class Videos < Base

			self.includes_on_finder = [:place => :area]
			self.friendly_id = false
			use_resource!
			paginate per_page: 10

			helpers do

				def video_params
					posts.require(:video).permit(:vimeo_id, :area_id, :transcript, :youtube_id, :title, :hero, :description, :place_id, :priority, :vimeo_thumbnail, :status, :country_include, :customer_approved, :customer_review, :approved_at, :_destroy, :youtube_id)
				end

			end

			resources :videos do
				
				desc "GET all videos with pagination."
				get do
					presenter paginate(Video.includes(:place => :area).order('areas.display_name ASC, places.display_name ASC'), per_page: params[:per_page], page: params[:page])
				end

				desc "GET video with id"
				get ':id' do
					video
				end

				desc "POST new video"
				post do
					video = context_resource
					# if !params.traverse("video","vimeo_id").blank?
					# 	response = Unirest.get("https://vimeo.com/api/oembed.json?url=http%3A//vimeo.com/" + video.vimeo_id.to_s) rescue nil
     #    		video.youtube_id = ""
     #    	elsif !params.traverse("video","youtube_id").blank?
			  #     response = Unirest.get("http://www.youtube.com/oembed?url=http://www.youtube.com/watch?v=#{@video.youtube_id}&format=json") rescue nil
			  #   end

			  #   if response
			  #     video.vimeo_thumbnail = response.body["thumbnail_url"]
			  #     video.title = response.body["title"] if video.title.blank?
			  #     video.description = response.body["description"] if video.description.blank?
			  #   end
					
					if video.save
						message "Video created."
					else
						standard_validation_error(video)
					end
				end

				desc "PUT edit on video"
				put ':id' do
					video = context_resource
					if video.update video_params
						message "Video updated."
					else
						standard_validation_error(video)
					end
				end

				desc "DELETE video"
				delete ':id' do
					video = context_resource
					video.destroy ? message("Video is destroyed." ) : standard_permission_denied_error
				end


			end

		end
	end
end