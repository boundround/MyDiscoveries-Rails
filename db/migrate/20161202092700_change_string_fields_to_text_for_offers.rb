class ChangeStringFieldsToTextForOffers < ActiveRecord::Migration
  def change
    change_column :offers, :name, :text
    change_column :offers, :specialNotes, :text
    change_column :offers, :operatingDaysStr, :text
    change_column :offers, :locationStart, :text
    change_column :offers, :locationEnd, :text
    change_column :offers, :pickupNotes, :text
    change_column :offers, :dropoffNotes, :text
    change_column :offers, :sellVouchers, :text
    change_column :offers, :onlyVouchers, :text
    change_column :offers, :customStr1, :text
    change_column :offers, :customStr2, :text
    change_column :offers, :customStr3, :text
    change_column :offers, :customStr4, :text
  end
end
