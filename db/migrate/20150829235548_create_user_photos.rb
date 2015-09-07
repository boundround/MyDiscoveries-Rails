class CreateUserPhotos < ActiveRecord::Migration
  def change
    create_table :user_photos do |t|
      t.string :title
      t.string :path
      t.string :caption
      t.string :status
      t.references :user, index: true
      t.references :story, index: true

      t.timestamps
    end
  end
end
