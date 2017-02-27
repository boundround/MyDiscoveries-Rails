class AddCreatedFromAxToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :created_from_ax, :boolean, default: false
  end
end
