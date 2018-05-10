class AddPriorityToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :priority, :integer, default: 10
  end
end
