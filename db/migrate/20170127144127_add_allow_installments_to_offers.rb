class AddAllowInstallmentsToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :allow_installments, :boolean, default: false
  end
end
