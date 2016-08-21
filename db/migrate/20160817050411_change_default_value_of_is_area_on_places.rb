class ChangeDefaultValueOfIsAreaOnPlaces < ActiveRecord::Migration
  def change
    change_column_default :places, :is_area, false
  end
end
