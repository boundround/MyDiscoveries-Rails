class CreateFamousFaces < ActiveRecord::Migration
  def change
    create_table :famous_faces do |t|
      t.string :name
      t.string :description
      t.string :photo

      t.timestamps
    end
  end
end
