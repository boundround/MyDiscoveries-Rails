class AddAxFilenameToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :ax_filename, :string
  end
end
