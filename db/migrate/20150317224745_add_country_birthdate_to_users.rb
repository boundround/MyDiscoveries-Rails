class AddCountryBirthdateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :country, :string
    add_column :users, :dateofbirth, :date
  end
end
