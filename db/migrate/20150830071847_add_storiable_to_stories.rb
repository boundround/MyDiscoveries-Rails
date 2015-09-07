class AddStoriableToStories < ActiveRecord::Migration
  def change
    add_column :stories, :storiable_id, :integer
    add_column :stories, :storiable_type, :string

    add_index :stories, [:storiable_id, :storiable_type]
  end
end
