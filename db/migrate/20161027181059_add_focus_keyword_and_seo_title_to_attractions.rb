class AddFocusKeywordAndSeoTitleToAttractions < ActiveRecord::Migration
  def change
    add_column :attractions, :focus_keyword, :text
    add_column :attractions, :seo_title, :text
  end
end
