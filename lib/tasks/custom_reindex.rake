namespace :algoliasearch do
  desc "Reindex model Story, Region, Post, Place, Country, Attraction"
  task :custom_reindex => :environment do
    Story.reindex!
    Region.reindex!
    Post.reindex!
    Place.reindex!
    Country.reindex!
    Attraction.reindex!
  end
end