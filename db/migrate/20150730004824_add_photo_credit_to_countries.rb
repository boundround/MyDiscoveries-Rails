class AddPhotoCreditToCountries < ActiveRecord::Migration
  def change
    add_column :countries, :photo_credit, :string
  end
end
