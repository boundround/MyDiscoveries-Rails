class CreateStoryTypes < ActiveRecord::Migration
  def change
    create_table :story_types do |t|
      t.string :name, default: ''
      t.timestamps
    end
  end
end
