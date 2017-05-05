class AddIndexToVariants < ActiveRecord::Migration
  def change
    add_index(
      :spree_variants,
      [:product_id, :maturity, :bed_type, :departure_city],
      name: 'index_variants_on_product_maturity_bed_type_departure_city'
    )
  end
end
