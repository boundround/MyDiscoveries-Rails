class AddCountryIncludeToFunFacts < ActiveRecord::Migration
  def change
    add_column :fun_facts, :country_include, :boolean
  end
end
