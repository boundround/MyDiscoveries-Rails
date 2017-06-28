class CreateStickers < ActiveRecord::Migration
  def change
    create_table :stickers do |t|
      t.string :file

      t.timestamps
    end
  end
end
