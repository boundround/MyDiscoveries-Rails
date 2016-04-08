class AddColumnsToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :publish_date, :datetime
    add_column :posts, :seo_friendly_url, :text
  end
end
