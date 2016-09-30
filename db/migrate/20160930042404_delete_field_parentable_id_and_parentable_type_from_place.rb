class DeleteFieldParentableIdAndParentableTypeFromPlace < ActiveRecord::Migration
  def change
    remove_column :places, :parentable_id, :integer
    remove_column :places, :parentable_type, :string
  end
end