namespace :slugs do
  desc "store old slug to table friendly_id_slugs"
  task :store_old_slug_of_stories => :environment do
    Story.all.each do |story|
      unless story.slug.blank?
        story.update(slug: story.slug)
      end
    end
  end
end