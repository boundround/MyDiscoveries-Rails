# This migration comes from spree_add_on (originally 20130911182513)
class AddNameAndDescriptionToLineItem < ActiveRecord::Migration
  def change
    add_column :spree_line_items, :name, :string, default: nil
    add_column :spree_line_items, :description, :text, default: nil
  end
end
