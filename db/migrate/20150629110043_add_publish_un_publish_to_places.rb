class AddPublishUnPublishToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :published_at, :datetime
    add_column :places, :unpublished_at, :datetime
  end
end
