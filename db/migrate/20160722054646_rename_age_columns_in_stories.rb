class RenameAgeColumnsInStories < ActiveRecord::Migration
  def change
    rename_column :stories, :min_age, :minimum_age
    rename_column :stories, :max_age, :maximum_age
  end
end
