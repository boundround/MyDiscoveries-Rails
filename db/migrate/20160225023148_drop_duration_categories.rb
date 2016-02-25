class DropDurationCategories < ActiveRecord::Migration
  def change
    drop_table :duration_categories
  end
end
