class AddPriorityAndBackgroundToFunFact < ActiveRecord::Migration
  def change
    add_column :fun_facts, :priority, :integer
    add_column :fun_facts, :background, :string
  end
end
