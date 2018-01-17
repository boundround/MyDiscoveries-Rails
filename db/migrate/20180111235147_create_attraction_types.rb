class CreateAttractionTypes < ActiveRecord::Migration
  def change
    create_table :attraction_types do |t|
      t.string :name, default: ''
      t.timestamps
    end
  end
end
