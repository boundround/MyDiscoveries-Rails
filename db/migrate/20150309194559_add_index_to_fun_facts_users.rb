class AddIndexToFunFactsUsers < ActiveRecord::Migration
  def change
    add_index :fun_facts_users, [:fun_fact_id, :user_id], :unique => true
  end
end
