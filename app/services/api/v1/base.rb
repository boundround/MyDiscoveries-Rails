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
			mount GamesUsers
			mount InfoBits
			mount JournalInfos
			mount Photos
			mount PhotosUsers
			mount PointsValues
			mount Programs
			mount ReviewsUsers
			mount SearchQueries
			mount StoriesUsers
			mount Transactions
			mount UserPhotos
			mount UserPhotosUsers
			mount Videos
			mount VideosUsers

		end
	end
end