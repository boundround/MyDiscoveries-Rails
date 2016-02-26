class CreateTableForStamps < ActiveRecord::Migration
  def change
    create_table :stamps do |t|
      t.string :serial
      t.references :place, index: true
    end
  end
end