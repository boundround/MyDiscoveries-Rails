namespace :slugs do
  desc "store old slug to table friendly_id_slugs"
  task :store_old_slug => :environment do
    Place.all.each do |place|
      place.update(slug: place.slug)
    end

    Story.all.each do |story|
      story.update(slug: story.slug)
    end

    Country.all.each do |country|
      country.update(slug: country.slug)
    end
  end
end
