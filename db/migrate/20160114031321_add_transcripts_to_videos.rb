class AddTranscriptsToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :transcript, :text
  end
end
