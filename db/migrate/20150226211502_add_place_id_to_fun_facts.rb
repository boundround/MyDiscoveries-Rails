class AddPlaceIdToFunFacts < ActiveRecord::Migration
  def change
    add_column :fun_facts, :place_id, :integer, index: true
  end
end
