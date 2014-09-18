class CreateSearchQueries < ActiveRecord::Migration
  def change
    create_table :search_queries do |t|
      t.string :term
      t.string :city
      t.string :country

      t.timestamps
    end
  end
end
