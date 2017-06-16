# This migration comes from spree_add_on (originally 20130613214421)
class CreateSpreeAddOns < ActiveRecord::Migration
  def change
    create_table :spree_add_ons do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
