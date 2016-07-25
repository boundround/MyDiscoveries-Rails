class AddPublishDateToStories < ActiveRecord::Migration
  def change
    add_column :stories, :publish_date, :datetime
  end
end
