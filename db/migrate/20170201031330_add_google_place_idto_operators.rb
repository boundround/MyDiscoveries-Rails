class AddGooglePlaceIdtoOperators < ActiveRecord::Migration
  def change
    add_column :operators, :google_place_id, :string, default: ""
  end
end
