class CreatePrograms < ActiveRecord::Migration
  def change
    create_table :programs do |t|
      t.string :name
      t.text :description
      t.text :yearlevelnotes
      t.string :cost
      t.string :programpath
      t.string :heroimagepath
      t.string :duration
      t.text :times
      t.string :booknowpath
      t.string :contact
      t.references :place, index: true

      t.timestamps
    end
  end
end
