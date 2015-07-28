class AddPhotoCreditToInfoBits < ActiveRecord::Migration
  def change
    add_column :info_bits, :photo_credit, :string
  end
end
