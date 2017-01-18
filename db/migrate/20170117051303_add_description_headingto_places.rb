class AddDescriptionHeadingtoPlaces < ActiveRecord::Migration
  def change
    add_column :places, :description_heading, :string, default: ""
  end
end
