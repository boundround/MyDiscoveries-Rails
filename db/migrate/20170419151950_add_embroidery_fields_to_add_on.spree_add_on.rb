# This migration comes from spree_add_on (originally 20140523154628)
class AddEmbroideryFieldsToAddOn < ActiveRecord::Migration
  def change
  	add_column :spree_line_item_add_ons, :embroidery_text, :string
  	add_column :spree_line_item_add_ons, :embroidery_font, :string
  	add_column :spree_line_item_add_ons, :embroidery_color, :string
  	add_column :spree_add_ons, :show_embroidery, :boolean, :default => false
  	add_column :spree_add_ons, :embroidery_options, :string

  end
end
