class CreateCategorizations < ActiveRecord::Migration
  def change
    create_table :categorizations, id: false do |t|
      t.string  :category_id
      t.integer :place_id

      t.timestamps
    end
  end
end
