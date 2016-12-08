class AddStartDateAndEndDateToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :startDate, :date
    add_column :offers, :endDate, :date
  end
end
