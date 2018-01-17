class ChangeOfferToProduct < ActiveRecord::Migration
  def change
    rename_table :offers, :products

    rename_column :related_offers, :offer_id, :product_id
    rename_column :related_offers, :related_offer_id, :related_product_id
    rename_table :related_offers, :related_products

    rename_column :offers_photos, :offer_id, :product_id
    rename_table :offers_photos, :products_photos

    rename_column :offers_attractions, :offer_id, :product_id
    rename_table :offers_attractions, :products_attractions

    rename_column :offers_countries, :offer_id, :product_id
    rename_table :offers_countries, :products_countries

    rename_column :offers_places, :offer_id, :product_id
    rename_table :offers_places, :products_places

    rename_column :offers_regions, :offer_id, :product_id
    rename_table :offers_regions, :products_regions

    rename_column :offers_subcategories, :offer_id, :product_id
    rename_table :offers_subcategories, :products_subcategories

    rename_column :offers_users, :offer_id, :product_id
    rename_table :offers_users, :products_users

    rename_column :offers_videos, :offer_id, :product_id
    rename_table :offers_videos, :products_videos

    rename_column :orders, :offer_id, :product_id
  end
end
