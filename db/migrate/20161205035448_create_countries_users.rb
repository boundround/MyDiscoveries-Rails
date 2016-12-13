class CreateCountriesUsers < ActiveRecord::Migration
  def change
    create_table :countries_users do |t|
      t.integer :user_id
      t.integer :country_id
    end
  end
end
