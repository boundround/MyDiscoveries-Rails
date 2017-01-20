class AddAttributeToOffer < ActiveRecord::Migration
  def change
  	add_column :offers, :supplier_product_code, :string
  	add_column :offers, :innovations_transaction_id, :string
  end
end
