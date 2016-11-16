class AddMetaDescriptionToCountries < ActiveRecord::Migration
  def change
    add_column :countries, :meta_description, :text
  end
end
