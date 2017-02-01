class AddLogoToOperators < ActiveRecord::Migration
  def change
    add_column :operators, :logo, :string
  end
end
