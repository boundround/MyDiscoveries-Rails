class AddFacableToFamousFaces < ActiveRecord::Migration
  def change
    add_column :famous_faces, :famous_faceable_id, :integer
    add_column :famous_faces, :famous_faceable_type, :string
  end
end
