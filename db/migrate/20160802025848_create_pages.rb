class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title, null: false
      t.string :hero_image
      t.text :hero_image_text
      t.text :brief_headline
      t.text :travel_links_headline

      t.timestamps
    end

    add_index :pages, :title, unique: true
  end
end
