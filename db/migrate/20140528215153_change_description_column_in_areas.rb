class ChangeDescriptionColumnInAreas < ActiveRecord::Migration
  def change
    change_column :areas, :description, :text
    change_column :photos, :fun_fact, :text
  end
end
