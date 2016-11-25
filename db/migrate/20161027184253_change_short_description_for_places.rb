class ChangeShortDescriptionForPlaces < ActiveRecord::Migration
  def change
    rename_column :places, :short_description, :meta_description
  end
end
