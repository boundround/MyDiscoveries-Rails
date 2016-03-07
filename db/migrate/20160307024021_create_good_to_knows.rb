class CreateGoodToKnows < ActiveRecord::Migration
  def change
    create_table :good_to_knows do |t|
      t.text :description, null: false
      t.boolean :show_on_page, default: true

      t.timestamps
    end
  end
end
