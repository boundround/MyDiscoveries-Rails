class ChildItem < ActiveRecord::Base
  belongs_to :itemable, :polymorphic => true
  belongs_to :parentable, :polymorphic => true

  after_create :split_child_item

  def split_child_item
  	@parent = self.parentable.class.find(self.parentable_id)
  	@child = self.itemable.class.find(self.itemable_id)
  	if self.parentable_type == "Region"
  	  if @child.regions.present?
  	  	@child.regions.destroy_all
  	  end
  	  @child.regions << @parent
  	end
  end
end
