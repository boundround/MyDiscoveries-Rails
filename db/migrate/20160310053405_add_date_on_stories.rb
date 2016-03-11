class AddDateOnStories < ActiveRecord::Migration
  def change
  	add_column :stories, :date, :date
  	add_column :stories, :min_age, :integer
  	add_column :stories, :max_age, :integer
  	add_column :stories, :author_name, :string
  end
end
