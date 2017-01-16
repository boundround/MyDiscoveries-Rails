class AddOPeratorstoOffer < ActiveRecord::Migration
  def change
    add_column :offers, :operator_id, :integer, index: true
  end
end
