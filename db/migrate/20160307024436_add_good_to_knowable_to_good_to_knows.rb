class AddGoodToKnowableToGoodToKnows < ActiveRecord::Migration
  def change
    add_reference :good_to_knows, :good_to_knowable, :polymorphic => true, index: {name: 'good_to_knowable_index'}
  end
end
