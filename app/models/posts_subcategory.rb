class PostsSubcategory < ActiveRecord::Base
  belongs_to :subcategory
  belongs_to :post
end
