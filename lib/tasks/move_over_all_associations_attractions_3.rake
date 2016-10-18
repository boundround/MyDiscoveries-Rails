namespace :attractions do
  desc "move over all associations place is_area false to attraction"
  task :move_over_all_associations_place_is_area_false_to_attraction_3 => :environment do
    
    Photo.where("place_id IS NOT NULL").each do |phto|
      place = Place.find_by_id(phto.place_id)
      unless place.blank?
        phto.update!(photoable_id: phto.place_id, photoable_type: place.is_area? ? "Place" : "Attraction")
      end
    end

    Video.where("place_id IS NOT NULL").each do |vdeo|
      place = Place.find_by_id(vdeo.place_id)
      unless place.blank?
        vdeo.update!(videoable_id: vdeo.place_id,videoable_type: place.is_area? ? "Place" : "Attraction")
      end
    end

    ThreeDVideo.where("place_id IS NOT NULL").each do |three_d_vid|
      place = Place.find_by_id(three_d_vid.place_id)
      unless place.blank?
        three_d_vid.update!(three_d_videoable_id: three_d_vid.place_id, three_d_videoable_type: place.is_area? ? "Place" : "Attraction")
      end
    end
  end
end