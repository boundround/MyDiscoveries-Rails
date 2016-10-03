class AddAlgoliaClicksNumberToSearchableTables < ActiveRecord::Migration
  def change
    add_column :places, :algolia_clicks, :integer, default: 0
    add_column :posts, :algolia_clicks, :integer, default: 0
    add_column :countries, :algolia_clicks, :integer, default: 0
    add_column :stories, :algolia_clicks, :integer, default: 0
  end
end
