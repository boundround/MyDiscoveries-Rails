namespace :slugs do
  desc "store old slug attraction to table friendly_id_slugs"
  task :store_old_slug_of_attractions => :environment do
    Attraction.all.each do |attraction|
      unless attraction.slug.blank?
        attraction.update(slug: attraction.slug, run_rake: true)
      end
    end
  end
end