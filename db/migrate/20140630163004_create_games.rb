class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :url
      t.references :place, index: true

      t.timestamps
    end
  end
end
