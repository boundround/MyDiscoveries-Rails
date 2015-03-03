class CreateJoinTableUserFunFact < ActiveRecord::Migration
  def change
    create_join_table :users, :fun_facts do |t|
      # t.index [:user_id, :fun_fact_id]
      # t.index [:fun_fact_id, :user_id]
    end
  end
end
