class AddPriorityToFunFacts < ActiveRecord::Migration
  def change
    add_column :fun_facts, :priority, :integer
  end
end
