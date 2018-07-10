class RenameProductPromotionRule < ActiveRecord::Migration
  def change
    rename_table :spree_product_promotion_rules, :spree_products_promotion_rules
  end
end
