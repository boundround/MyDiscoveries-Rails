class AddPolymorphicToTablePlaces < ActiveRecord::Migration
  def change
    add_column :places, :parentable_id, :integer, index: true
    add_column :places, :parentable_type, :string, index: true
  end
end
