class AddLivnProductIdToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :livn_product_id, :integer
  end
end
