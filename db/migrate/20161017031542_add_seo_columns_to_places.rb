class AddSeoColumnsToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :focus_keyword, :text
    add_column :places, :seo_title, :text
  end
end
