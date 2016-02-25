module API
	module V1
		class Programs < Base
			
			self.includes_on_finder = [:webresources]
			self.friendly_id = false
			use_resource!
			paginate per_page: 10

			helpers do

				def program_params
					posts.require(:program).permit(:name, :description, :yearlevelnotes, :cost, 
						 :programpath, :heroimagepath, :duration, :times, :booknowpath, :contact, 
						 :place_id, :programsubject_list, :programactivity_list, :programyearlevel_list, :tag_list)
				end

				def set_program_constants()
					ylvec = "K,1,2,3,4,5,6,7,8,9,10,11,12"
    			subjects = "Arts, Business & Enterprise, Education, English, Geography, Health & Physical Education, History, Language, Mathematics, Science, Society & Environment, Technology"
				end

			end

			resources :programs do

				desc "GET all Programs with pagination."
				get do
					presenter paginate(Program.includes(:webresources).all, per_page: params[:per_page], page: params[:page])
				end

				desc "GET Program id"
				get ':id' do
					program
				end

				desc "POST new program"
				post do
					program = context_resource

					if program.save
						message "Program created."
					else
						standard_validation_error(program)
					end
				end

				desc "PUT edit on program"
				put ':id' do
					set_program_constants()
					program = context_resource
					if program.update program_params
						message "Program updated."
					else
						standard_validation_error(program)
					end
				end

				desc "DELETE program"
				delete ':id' do
					program = context_resource
					program.destroy ? message("Program is destroyed." ) : standard_permission_denied_error
				end

				desc "GET tags"
				get ':sort/:direction' do
					params[:sort] ||= "id"
    			params[:direction] ||= "asc"
					presenter paginate(Program.order(params[:sort] + " " + params[:direction]), per_page: params[:per_page], page: params[:page])
				end
			end
		end
	end
end