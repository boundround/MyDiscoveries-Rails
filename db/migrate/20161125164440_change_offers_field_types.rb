class ChangeOffersFieldTypes < ActiveRecord::Migration
  def change
    change_column :offers, :includes, :text
    change_column :offers, :operatingSchedule, :text
    change_column :offers, :highlightsStr, :text
    change_column :offers, :itineraryStr, :text
    change_column :offers, :description, :text
    change_column :offers, :highlightsStr, :text
    change_column :offers, :voucherInstructions, :text
    change_column :offers, :duration, :bigint
  end
end
