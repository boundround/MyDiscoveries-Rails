class DeleteAndRenameColumnsInPages < ActiveRecord::Migration
  def change
    rename_column :pages, :brief_headline, :promo_headline
    remove_column :pages, :travel_links_headline
  end
end
