class ChangeCountryDescriptionInCountries < ActiveRecord::Migration
  def up
   change_column :countries, :description, :text
  end

  def down
   change_column :countries, :description, :string
  end
end
