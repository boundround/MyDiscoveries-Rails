class CreateSpecials < ActiveRecord::Migration
  def change
    create_table :specials do |t|
      t.text :description
      t.references :place, index: true

      t.timestamps
    end
  end
end
