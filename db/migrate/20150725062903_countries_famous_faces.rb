class CountriesFamousFaces < ActiveRecord::Migration
  def change
    create_table :countries_famous_faces do |t|
      t.integer :country_id
      t.integer :famous_face_id
    end
  end
end
