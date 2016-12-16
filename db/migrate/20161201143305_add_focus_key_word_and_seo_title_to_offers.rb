class AddFocusKeyWordAndSeoTitleToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :focus_keyword, :text
    add_column :offers, :seo_title, :text    
  end
end
