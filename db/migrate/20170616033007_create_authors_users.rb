class CreateAuthorsUsers < ActiveRecord::Migration
  def change
    create_table :authors_users do |t|
      t.integer :author_id
      t.integer :user_id

      t.index([:author_id, :user_id], unique: true)
    end
  end
end
