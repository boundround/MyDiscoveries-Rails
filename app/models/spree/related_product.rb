class Spree::RelatedProduct < ActiveRecord::Base
  belongs_to :product
  belongs_to :related_product,
    class_name: Spree::Product,
    foreign_key: :spree_related_product_id
end
