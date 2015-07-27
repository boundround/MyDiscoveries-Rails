class CountriesFunFacts < ActiveRecord::Migration
  def change
    create_table :countries_fun_facts do |t|
      t.integer :country_id
      t.integer :fun_fact_id
    end
  end
end
