class AddIndexToAreas < ActiveRecord::Migration
  def change
    add_index :areas, :display_name
  end
end
