namespace :slugs do
  desc "store old slug to table friendly_id_slugs"
  task :store_old_slug_of_countries => :environment do
    Country.all.each do |country|
      unless country.slug.blank?
        country.update(slug: country.slug)
      end
    end
  end
end
