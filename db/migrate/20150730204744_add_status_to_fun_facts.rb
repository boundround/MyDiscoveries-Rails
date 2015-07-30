class AddStatusToFunFacts < ActiveRecord::Migration
  def change
    add_column :fun_facts, :status, :string
  end
end
