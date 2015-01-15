class CreateFunFacts < ActiveRecord::Migration
  def change
    create_table :fun_facts do |t|
      t.text :content
      t.string :reference
      t.references :area, index: true

      t.timestamps
    end
  end
end
