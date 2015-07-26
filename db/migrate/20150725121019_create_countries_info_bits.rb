class CreateCountriesInfoBits < ActiveRecord::Migration
  def change
    create_table :countries_info_bits do |t|
      t.integer :country_id
      t.integer :info_bit_id
    end
  end
end
