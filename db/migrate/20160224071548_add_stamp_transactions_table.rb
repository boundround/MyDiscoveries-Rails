class AddStampTransactionsTable < ActiveRecord::Migration
  def change
    create_table :stamp_transactions do |t|
      t.string :user_info

      t.references :stamp, index: true
    end
  end
end