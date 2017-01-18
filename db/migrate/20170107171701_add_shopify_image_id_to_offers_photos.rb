class AddShopifyImageIdToOffersPhotos < ActiveRecord::Migration
  def change
    add_column :offers_photos, :shopify_image_id, :string
  end
end
