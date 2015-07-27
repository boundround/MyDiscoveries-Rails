class AddPublishedStatusToCountries < ActiveRecord::Migration
  def change
    add_column :countries, :published_status, :string
  end
end
