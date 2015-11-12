class AddAssetIdToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :asset_id, :integer
  end
end
