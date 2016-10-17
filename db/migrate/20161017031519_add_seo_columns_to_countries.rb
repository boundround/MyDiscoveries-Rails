class AddSeoColumnsToCountries < ActiveRecord::Migration
  def change
    add_column :countries, :focus_keyword, :text
    add_column :countries, :seo_title, :text
  end
end
