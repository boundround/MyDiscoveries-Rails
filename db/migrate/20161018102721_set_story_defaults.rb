class SetStoryDefaults < ActiveRecord::Migration
  def change
    change_column_default :stories, :status, 'draft'
    change_column_default :stories, :content, 'Tell your story and add images here'
  end
end
