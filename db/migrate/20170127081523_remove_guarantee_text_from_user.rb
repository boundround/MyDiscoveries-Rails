class RemoveGuaranteeTextFromUser < ActiveRecord::Migration
  def change
  	remove_column :users, :guarantee_text
  end
end
