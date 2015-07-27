class AddColumnsToCountries < ActiveRecord::Migration
  def change
    add_column :countries, :description, :string
    add_column :countries, :capital_city, :string
    add_column :countries, :capital_city_description, :string
    add_column :countries, :currency_code, :string
    add_column :countries, :official_language, :string
    add_column :countries, :tallest_mountain, :string
    add_column :countries, :tallest_mountain_height, :integer
    add_column :countries, :longest_river, :string
    add_column :countries, :longest_river_length, :integer
  end
end
