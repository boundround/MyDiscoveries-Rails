class AddDisplayAddressToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :display_address, :string
  end
end
