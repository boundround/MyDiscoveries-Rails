class ChangeOpeningHoursTypeInPlaces < ActiveRecord::Migration
  def change
    change_column :places, :opening_hours, :text
  end
end
