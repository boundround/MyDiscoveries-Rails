class AddSlugToOperator < ActiveRecord::Migration
  def change
    add_column :operators, :slug, :string
    add_index :operators, :slug
  end
end
