class CreateLandings < ActiveRecord::Migration
  def change
    create_table :landings do |t|
      t.string :from_url
      t.string :to_url
      t.references :user, index: true

      t.timestamps
    end
  end
end
