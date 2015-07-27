class AddLongAndShortNamesToCountries < ActiveRecord::Migration
  def change
    add_column :countries, :short_name, :string
    add_column :countries, :long_name, :string
  end
end
