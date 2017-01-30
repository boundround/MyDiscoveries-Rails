class AddGuaranteeTextToUser < ActiveRecord::Migration
  def change
  	add_column :users, :guarantee_text, :string
  end
end
