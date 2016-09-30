namespace :places_make_polymorphic do
  desc "Change to Parent to parentable on place model"
  task :places_change_parent_to_parentable => :environment do
    Place.where('parent_id is not null').each do |place|
      old_parent = place.parent_id
      ChildItem.create!(itemable_id: place.id, itemable_type: "Place", parentable_id: old_parent, parentable_type: "Place")
    end
  end
end
