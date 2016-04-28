class CreateSearchRequests < ActiveRecord::Migration
  def change
    create_table :search_requests do |t|
      t.string :name
      t.string :email
      t.string :term

      t.timestamps
    end
  end
end
