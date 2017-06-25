class AddAccommodationToSpreeVariants < ActiveRecord::Migration
  def change
    add_column :spree_variants, :accommodation, :string
  end
end
