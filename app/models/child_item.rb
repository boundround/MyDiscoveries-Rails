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
  	end
  end
end
