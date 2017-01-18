class RenameColumnPublishOnOffer < ActiveRecord::Migration
  def change
  	rename_column :offers, :publishStartDate, :publishstartdate
  	rename_column :offers, :publishEndDate, :publishenddate
  end
end
