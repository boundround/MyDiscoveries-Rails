class ChangeAlgoliaIdOnPlaces < ActiveRecord::Migration
  def change
  	change_column :places, :algolia_id, :string
  end
end
