class AddPageHeaderToPages < ActiveRecord::Migration
  def change
    add_column :pages, :page_header, :string
  end
end
