class AddMarketingHeadlineToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :marketing_headline, :string, default: ""
  end
end
