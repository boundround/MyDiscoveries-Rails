namespace :countries do
  desc "Copy over place photos to countries"
  task :copy_place_photos => :environment do
    Country.all.each do |country|
      if country.old_photos.present?
        country.old_photos.each do |photo|
          if photo.photoable.blank?
            photo.photoable = country
            if photo.country_hero == true
              photo.hero = true
            else
              photo.hero = false
            end
            photo.save
          else
            new_photo = photo.dup
            new_photo.photoable = country
            if new_photo.country_hero == true
              new_photo.hero = true
            else
              new_photo.hero = false
            end
            new_photo.save
          end
        end
      end
    end
  end
end
