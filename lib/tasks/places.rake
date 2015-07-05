namespace :places do
  desc "Publish places with cron on certain time"
  task :publish => :environment do
    Place.publishing_queue.each do |place|
      place.publish
    end

    Place.removal_queue.each do |place|
      place.unpublish
    end
  end
end
