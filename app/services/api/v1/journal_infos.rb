module API
	module V1
		class JournalInfos < Base
			
			self.friendly_id = false
			use_resource!

			resources :journal_info do

				desc "GET journal info with id"
				get ':id' do
					journal_info
				end

			end

		end
	end
end