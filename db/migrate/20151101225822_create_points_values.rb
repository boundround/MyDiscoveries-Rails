class CreatePointsValues < ActiveRecord::Migration
  def change
    create_table :points_values do |t|
      t.string :type
      t.integer :value

      t.timestamps
    end
  end
end
