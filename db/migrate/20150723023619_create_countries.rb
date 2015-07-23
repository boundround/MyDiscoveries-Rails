class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :display_name
      t.string :country_code

      t.timestamps
    end
  end
end
