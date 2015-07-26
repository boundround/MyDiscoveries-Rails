class CreateInfoBits < ActiveRecord::Migration
  def change
    create_table :info_bits do |t|
      t.string :title
      t.text :description
      t.string :photo

      t.timestamps
    end
  end
end
