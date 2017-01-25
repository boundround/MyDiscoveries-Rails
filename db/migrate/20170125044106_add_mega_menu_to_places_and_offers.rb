class AddMegaMenuToPlacesAndOffers < ActiveRecord::Migration
  def change
  	add_column :places, :show_in_mega_menu, :boolean, default: false
  	add_column :offers, :show_in_mega_menu, :boolean, default: false
  end
end
