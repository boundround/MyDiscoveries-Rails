class ChangeTypeColumnInPointsValues < ActiveRecord::Migration
  def change
    rename_column :points_values, :type, :asset_type
  end
end
