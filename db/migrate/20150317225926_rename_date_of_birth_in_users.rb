class RenameDateOfBirthInUsers < ActiveRecord::Migration
  def change
    rename_column :users, :dateofbirth, :date_of_birth
  end
end
