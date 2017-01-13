class ChangeShortDescriptionForAttractions < ActiveRecord::Migration
  def change
    add_column :attractions, :meta_description, :text
  end
end
