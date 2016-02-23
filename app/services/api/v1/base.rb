module API
	module V1
		class Base < API::Base
			version "v1", using: :path

			include Resources

			mount Places
			mount Areas
			mount AreasUsers
			mount BugPosts
			mount States
			mount Discounts
			mount FactualPlaces
			mount FamousFaces
			mount FunFacts
			mount FunFactsUsers
			mount Games

		end
	end
end