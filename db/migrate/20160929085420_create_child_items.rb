class CreateChildItems < ActiveRecord::Migration
  def change
    create_table :child_items do |t|
      t.string :itemable_type
      t.integer :itemable_id
      t.string :parentable_type
      t.integer :parentable_id

      t.timestamps
    end
    add_index :child_items, :itemable_type
    add_index :child_items, :itemable_id
    add_index :child_items, :parentable_type
    add_index :child_items, :parentable_id
  end
end
