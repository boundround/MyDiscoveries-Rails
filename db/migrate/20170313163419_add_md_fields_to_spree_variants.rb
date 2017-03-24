class AddMdFieldsToSpreeVariants < ActiveRecord::Migration
  def change
    add_column :spree_variants, :maturity, :integer, default: 0
    add_column :spree_variants, :bed_type, :integer, default: 0
    add_column :spree_variants, :departure_city, :string
    add_column :spree_variants, :sumcode, :string
    add_column :spree_variants, :item_code, :string
    add_column :spree_variants, :description, :string
    add_column :spree_variants, :room_type, :string
  end
end
