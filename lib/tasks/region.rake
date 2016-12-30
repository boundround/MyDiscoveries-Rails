namespace :region do
  desc "Clears cached places and attractions"
  task :flush_places => :environment do
    Region.all.each do |region|
      Rails.cache.delete([region, "places"])
    end
  end

  task :flush_attractions => :environment do
    Region.all.each do |region|
      Rails.cache.delete([region, "attractions"])
    end
  end

  task :fill_places_cache => :environment do
    Region.all.each do |region|
      region.places
    end
  end

  task :fill_attractions_cache => :environment do
    Region.all.each do |region|
      region.attractions
    end
  end
end
