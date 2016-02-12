class AddTop100AndViatorLinkToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :top_100, :boolean, default: false
    add_column :places, :viator_link, :text, default: ""
  end
end
