class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.string :title
      t.text :content
      t.references :user, index: true
      t.references :user_photo, index: true

      t.timestamps
    end
  end
end
