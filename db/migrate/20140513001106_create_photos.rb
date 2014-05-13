class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :title
      t.string :credit
      t.string :path
      t.references :area, index: true

      t.timestamps
    end
  end
end
