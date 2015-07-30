class AddStatusToInfoBits < ActiveRecord::Migration
  def change
    add_column :info_bits, :status, :string
  end
end
