class ChangeInnovationTransactionIdInOffers < ActiveRecord::Migration
  def change
    add_column :offers, :child_item_id, :string, default: ""
    add_column :offers, :item_id, :string, default: ""
  end
end
