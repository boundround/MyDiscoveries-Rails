namespace :copy_places do
  desc "Copy places is area false to table attractions"
  task :is_area_false_to_attractions => :environment do
    Place.where(is_area: false).each do |place|
      Attraction.create(place.attributes).save
    end
  end
end