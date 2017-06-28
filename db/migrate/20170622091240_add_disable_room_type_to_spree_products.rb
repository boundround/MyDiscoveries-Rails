class AddDisableRoomTypeToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :disable_room_type, :boolean, default: false    
  end
end
