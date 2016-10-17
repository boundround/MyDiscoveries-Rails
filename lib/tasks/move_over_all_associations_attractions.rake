namespace :attractions do
  desc "move over all associations place is_area false to attraction"
  task :move_over_all_associations_place_is_area_false_to_attraction => :environment do

      PlacesUser.all.each do |p_user|
        AttractionsUser.create(user_id: p_user.user_id, attraction_id: p_user.place_id) 
      end

      CustomersPlace.all.each do |cus_p|
        CustomersAttraction.create(user_id: cus_p.user_id, attraction_id: cus_p.place_id)
      end

      SimilarPlace.all.each do |sim_p|
        SimilarAttraction.create(attraction_id: sim_p.place_id, similar_place_id: sim_p.similar_place_id, created_at: sim_p.created_at, updated_at: sim_p.updated_at)
      end

      PlacesSubcategory.all.each do |p_subcat|
        AttractionsSubcategory.create(attraction_id: p_subcat.place_id, subcategory_id: p_subcat.subcategory_id, desc: p_subcat.desc)
      end

      PlacesPost.all.each do |p_post|
        AttractionsPost.create(attraction_id: p_post.place_id, post_id: p_post.post_id)
      end

      PlacesStory.all.each do |p_story|
        AttractionsStory.create(attraction_id: p_story.place_id, story_id: p_story.story_id, created_at: p_story.created_at, updated_at: p_story.updated_at)
      end

  end
end