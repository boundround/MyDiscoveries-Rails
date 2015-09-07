class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.text :content
      t.integer :reviewable_id
      t.string :reviewable_type

      t.timestamps
    end

    add_index :reviews, [:reviewable_id, :reviewable_type]
  end
end
