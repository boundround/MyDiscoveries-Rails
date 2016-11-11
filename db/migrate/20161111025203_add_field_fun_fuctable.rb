class AddFieldFunFuctable < ActiveRecord::Migration
  def change
    add_column :fun_facts, :fun_factable_id, :integer
    add_column :fun_facts, :fun_factable_type, :string
  end
end