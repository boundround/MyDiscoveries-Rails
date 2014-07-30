class AddPublishedStatusColumnToAreas < ActiveRecord::Migration
  def change
    add_column :areas, :published_status, :string
  end
end
