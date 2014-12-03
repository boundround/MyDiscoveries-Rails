class DropFkColumnsFromFunFacts < ActiveRecord::Migration
  def change
    remove_column :fun_facts, :place_id
    remove_column :fun_facts, :area_id
  end
end
