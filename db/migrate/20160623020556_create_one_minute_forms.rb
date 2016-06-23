class CreateOneMinuteForms < ActiveRecord::Migration
  def change
    create_table :one_minute_forms do |t|
      t.string :results
      t.integer :user_id

      t.timestamps
    end
  end
end
