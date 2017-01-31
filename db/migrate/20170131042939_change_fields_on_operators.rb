class ChangeFieldsOnOperators < ActiveRecord::Migration
  def change
    change_column :operators, :name, :text, default: ""
    change_column :operators, :companyName, :text, default: ""
    change_column :operators, :tradingName, :text, default: ""
    change_column :operators, :description, :text, default: ""
    change_column :operators, :address1, :text, default: ""
    change_column :operators, :address2, :text, default: ""
    change_column :operators, :contactName, :text, default: ""
    change_column :operators, :resContactName, :text, default: ""
    change_column :operators, :logoUrl, :text, default: ""
    change_column :operators, :tncUrl, :text, default: ""
  end
end
