class ChildItem < ActiveRecord::Base
  belongs_to :itemable, :polymorphic => true
  belongs_to :parentable, :polymorphic => true

  after_create :split_child_item

  def split_child_item
  	if self.parentable_type == "Region"
  	  @parent = self.parentable
  	  @child = self.itemable
  	  if @child.regions.present?
  	  	@child.regions.destroy_all
  	  end
  	  @child.regions << @parent
  	elsif self.parentable_type == "Place"
  	  @parent = self.parentable
  	  @child = self.itemable
  	  if @child.places.present?
  	  	@child.places.destroy_all
  	  end
  	  @child.places << @parent
  	end
  end
end
