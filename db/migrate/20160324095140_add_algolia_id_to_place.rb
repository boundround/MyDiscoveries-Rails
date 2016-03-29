class AddAlgoliaIdToPlace < ActiveRecord::Migration
  def change
  	add_column :places, :algolia_id, :integer
  end
end
