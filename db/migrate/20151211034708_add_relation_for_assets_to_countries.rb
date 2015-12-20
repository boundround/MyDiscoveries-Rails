class AddRelationForAssetsToCountries < ActiveRecord::Migration
  def change
     add_column :reviews, :country_id, :integer
     add_column :stories, :country_id, :integer
     add_column :user_photos, :country_id, :integer
  end
end
