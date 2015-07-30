class AddPhotoCreditToFunFacts < ActiveRecord::Migration
  def change
    add_column :fun_facts, :photo_credit, :string
  end
end
