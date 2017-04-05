class AddTestProductToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :test_product, :boolean, default: false
  end
end
