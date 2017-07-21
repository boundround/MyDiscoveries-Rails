class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string :name
      t.string :link
      t.string :image
      t.text :description

      t.timestamps
    end
  end
end
