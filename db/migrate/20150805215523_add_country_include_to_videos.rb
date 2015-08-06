class AddCountryIncludeToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :country_include, :boolean
  end
end
