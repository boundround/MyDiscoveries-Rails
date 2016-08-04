class AddSeoFriendlyUrlToStories < ActiveRecord::Migration
  def change
    add_column :stories, :seo_friendly_url, :text
  end
end
