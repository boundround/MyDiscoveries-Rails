namespace :slugs do
  desc "store old slug to table friendly_id_slugs"
  task :store_old_slug_of_places => :environment do
    Place.where(is_area: true).each do |place|
      unless place.slug.blank?
        place.update(slug: place.slug, run_rake: true)
      end
    end
  end
end