class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.text :description
      t.references :place, index: true

      t.timestamps
    end
  end
end
