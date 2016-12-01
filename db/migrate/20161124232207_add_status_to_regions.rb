class AddStatusToRegions < ActiveRecord::Migration
  def change
    add_column :regions, :status, :string, default: ""
  end
end
