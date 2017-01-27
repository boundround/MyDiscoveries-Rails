class AddFeaturedToOffer < ActiveRecord::Migration
  def change
  	add_column :offers, :featured, :boolean, default: false
  end
end
