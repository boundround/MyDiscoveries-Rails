class AddHeroPhotoToFunFacts < ActiveRecord::Migration
  def change
    add_column :fun_facts, :hero_photo, :string
  end
end
