class AddFooterIncludeToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :footer_include, :boolean
  end
end
