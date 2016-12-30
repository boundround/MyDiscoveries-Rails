class ChildItem < ActiveRecord::Base
  belongs_to :itemable, :polymorphic => true
  belongs_to :parentable, :polymorphic => true

  after_create :split_child_item

  def split_child_item
    if self.parentable_type == "Region"
      parent = self.parentable #Region will be the parent
      child = self.itemable #Child item, it can be Place or Attraction
      child.regions = [parent] #Storing data to join table, can be attractions_regions or places_regions
    elsif self.parentable_type == "Place"
      parent = self.parentable #Place will be the parent
      child = self.itemable #Child item, will be Attaction
      child.places = [parent] #Storing data to join table attractions_places
    end
  end
end
