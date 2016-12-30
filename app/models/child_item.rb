class ChildItem < ActiveRecord::Base
  belongs_to :itemable, :polymorphic => true
  belongs_to :parentable, :polymorphic => true

  after_create :split_child_item

  def split_child_item
  	if self.parentable_type == "Region"
  	  parent = self.parentable #Region that will be the parent
  	  child = self.itemable #Child item, it can be Place or Attraction
      child.regions = [parent] #Storing data to join table, can be attractions_regions or places_regions
  	end
  end
end
