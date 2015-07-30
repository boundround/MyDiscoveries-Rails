class AddStatusToFamousFaces < ActiveRecord::Migration
  def change
    add_column :famous_faces, :status, :string
  end
end
