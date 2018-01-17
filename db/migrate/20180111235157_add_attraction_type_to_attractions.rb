class AddAttractionTypeToAttractions < ActiveRecord::Migration
  def change
    attraction_type = AttractionType.create(name: "Things To Do")
    add_reference :attractions, :attraction_type, index: true

    Attraction.update_all attraction_type_id: attraction_type.id
  end
end
