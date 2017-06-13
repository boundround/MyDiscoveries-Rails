class AddFieldOtherToOffer < ActiveRecord::Migration
  def change
  	add_column :spree_products, :other, :text
  end
end
