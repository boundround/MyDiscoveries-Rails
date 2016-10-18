namespace :attractions do
  desc "move over all associations place is_area false to attraction"
  task :move_over_all_associations_place_is_area_false_to_attraction_2 => :environment do
    
    rate_all          = Rate.all.map(&:rateable_id)
    rating_cache_all  = RatingCache.all.map(&:cacheable_id)

    Place.where("is_area = ?", "false").each do |place|
      unless place.good_to_knows.blank?
        place.good_to_knows.each do |p_gtk|
          p_gtk.update!(good_to_knowable_type: "Attraction")
        end
      end

      unless place.reviews.blank?
        place.reviews.each do |p_review|
          p_review.update!(reviewable_type: "Attraction")
        end
      end

      unless place.deals.blank?
        place.deals.each do |p_deal|
          p_deal.update!(dealable_type: "Attraction")
        end
      end

      if rate_all.include?(place.id)
        Rate.where(rateable_id: place.id).each do |rate|
          rate.update!(rateable_type: "Attraction")
        end
      end

      if rating_cache_all.include?(place.id)
        RatingCache.where(cacheable_id: place.id).each do |ca_rate|
          ca_rate.update!(cacheable_type: "Attraction")
        end
      end

    end
  end
end