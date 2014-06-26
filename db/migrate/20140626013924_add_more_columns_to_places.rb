class AddMoreColumnsToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :opening_hours, :string
    add_column :places, :phone_number, :string
    add_column :places, :website, :string
    add_column :places, :logo, :string
  end
end
