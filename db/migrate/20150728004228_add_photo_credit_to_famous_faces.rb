class AddPhotoCreditToFamousFaces < ActiveRecord::Migration
  def change
    add_column :famous_faces, :photo_credit, :string
  end
end
