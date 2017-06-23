class AddDepartureDateToSpreeVariants < ActiveRecord::Migration
  def change
    add_column :spree_variants, :departure_date, :datetime
  end
end
