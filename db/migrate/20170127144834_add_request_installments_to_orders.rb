class AddRequestInstallmentsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :request_installments, :boolean, default: false
  end
end
