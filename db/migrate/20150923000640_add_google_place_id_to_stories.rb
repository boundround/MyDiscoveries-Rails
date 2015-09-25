class AddGooglePlaceIdToStories < ActiveRecord::Migration
  def change
    add_column :stories, :google_place_id, :string
  end
end
