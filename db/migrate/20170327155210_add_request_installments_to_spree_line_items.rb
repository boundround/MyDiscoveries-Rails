class AddRequestInstallmentsToSpreeLineItems < ActiveRecord::Migration
  def change
    add_column :spree_line_items, :request_installments, :boolean, default: false
  end
end
