class AddSlugToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :slug, :string, index: true
  end
end
