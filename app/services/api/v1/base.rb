module API
	module V1
		class Base < API::Base
			version "v1", using: :path
	
			mount Places
			mount Areas

		end
	end
end