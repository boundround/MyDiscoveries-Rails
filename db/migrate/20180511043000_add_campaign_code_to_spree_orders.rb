class AddCampaignCodeToSpreeOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :campaign_code, :string, default: ''
  end
end
