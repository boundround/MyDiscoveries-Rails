class AddColumnToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :address, :string
  end
end
