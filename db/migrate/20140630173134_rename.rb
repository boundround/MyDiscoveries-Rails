class Rename < ActiveRecord::Migration
  def change
    rename_table :specials, :discounts
  end
end
