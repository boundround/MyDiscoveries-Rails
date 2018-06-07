class ProductsStory < ActiveRecord::Base
  belongs_to :product, :foreign_key => :product_id
  belongs_to :story, :foreign_key => :story_id
end
