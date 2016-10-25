namespace :parent_attractions do
  desc "Create attractions parentable"
  task :create_parentable => :environment do
    area_true = Place.where(is_area: true).map(&:id)
    Attraction.where('parent_id is not null').each do |attrac|
      old_parent = attrac.parent_id
      if area_true.include?(old_parent)
        parentable_type = "Place"
      else
        parentable_type = "Attraction"
      end
      
      ChildItem.create!(itemable_id: attrac.id, itemable_type: "Attraction", parentable_id: old_parent, parentable_type: parentable_type)
    end
  end
end