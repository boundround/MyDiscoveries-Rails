class StoriesSubcategory < ActiveRecord::Base
  belongs_to :story
  belongs_to :subcategory
end
