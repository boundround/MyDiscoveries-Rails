class AddCreatedFromAxToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :created_from_ax, :boolean, default: false
  end
end
