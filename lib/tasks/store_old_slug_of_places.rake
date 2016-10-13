namespace :slugs do
  desc "store old slug to table friendly_id_slugs"
  task :store_old_slug_of_places => :environment do
    Place.all.each do |place|
      unless place.slug.blank?
        place.update(slug: place.slug)
      end
    end
  end
end