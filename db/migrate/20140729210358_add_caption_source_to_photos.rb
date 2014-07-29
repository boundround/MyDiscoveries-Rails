class AddCaptionSourceToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :caption_source, :string
  end
end
