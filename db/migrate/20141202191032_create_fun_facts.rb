class CreateFunFacts < ActiveRecord::Migration
  def change
    create_table :fun_facts do |t|
      t.string :text
      t.references :area, index: true
      t.references :place, index: true

      t.timestamps
    end
  end
end
