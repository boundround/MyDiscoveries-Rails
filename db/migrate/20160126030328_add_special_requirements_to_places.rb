class AddSpecialRequirementsToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :special_requirements, :text
  end
end
