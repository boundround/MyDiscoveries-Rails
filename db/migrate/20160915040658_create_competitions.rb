class CreateCompetitions < ActiveRecord::Migration
  def change
    create_table :competitions do |t|
      t.text :url
      t.text :title
      t.string :image

      t.timestamps
    end
  end
end
