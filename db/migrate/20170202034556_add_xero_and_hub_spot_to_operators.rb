class AddXeroAndHubSpotToOperators < ActiveRecord::Migration
  def change
    add_column :operators, :xero_id, :string
    add_column :operators, :hubspot_id, :string
  end
end
