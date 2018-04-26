class AddCanonicalUrlToStories < ActiveRecord::Migration
  def change
    add_column :stories, :canonical_url, :string, default: ''
  end
end
