class CreateSuggestedPlaces < ActiveRecord::Migration
  def change
    create_table :suggested_places do |t|
      t.string :user_ip
      t.string :place
      t.string :city
      t.string :country

      t.timestamps
    end
  end
end
