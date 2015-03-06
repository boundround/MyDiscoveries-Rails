class AddPrimaryKeyToFunFactsUsers < ActiveRecord::Migration
  def change
    add_column :fun_facts_users, :id, :primary_key
  end
end
