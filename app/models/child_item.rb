class ChildItem < ActiveRecord::Base
  belongs_to :itemable, :polymorphic => true
  belongs_to :parentable, :polymorphic => true

  #we save the relations to hbtm table after created ChildItem record
  after_create :split_child_item

  def split_child_item
    if self.parentable_type == "Region"
      #if the parent of ChildItem is Region 
      # we create a child related to region(parent) 
      # to join table attraction_regions or places_regions with the method below 
      self.itemable.regions = [self.parentable]
    elsif self.parentable_type == "Place"
      #if the parent of ChildItem is Place 
      # we create a child related to place(parent) 
      # to join table attraction_places with the method below 
      self.itemable.places = [self.parentable]
    end
  end
end
