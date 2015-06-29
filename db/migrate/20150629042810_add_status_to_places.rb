class AddStatusToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :status, :string
  end
end
