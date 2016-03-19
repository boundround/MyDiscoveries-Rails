module Routes
	module Constraints
		class SubCategories
			
			def matches? request
				request.params['age_ranges'] =~ /^[0-9]?[0-9]-[0-9]?[0-9]$/
			end

		end
	end
end