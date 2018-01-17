class ProductOfferRename < ActiveRecord::Migration
  def change
    rename_table :products, :offers

    rename_table :related_products, :related_offers
    rename_column :related_offers, :product_id, :offer_id
    rename_column :related_offers, :related_product_id, :related_offer_id

    rename_table :products_photos, :offers_photos
    rename_column :offers_photos, :product_id, :offer_id

    rename_table :products_attractions, :offers_attractions
    rename_column :offers_attractions, :product_id, :offer_id

    rename_table :products_countries, :offers_countries
    rename_column :offers_countries, :product_id, :offer_id

    rename_table :products_places, :offers_places
    rename_column :offers_places, :product_id, :offer_id

    rename_table :products_regions, :offers_regions
    rename_column :offers_regions, :product_id, :offer_id

    rename_table :products_subcategories, :offers_subcategories
    rename_column :offers_subcategories, :product_id, :offer_id

    rename_table :products_users, :offers_users
    rename_column :offers_users, :product_id, :offer_id

    rename_table :products_videos, :offers_videos
    rename_column :offers_videos, :product_id, :offer_id

    rename_column :orders, :product_id, :offer_id
  end
end
