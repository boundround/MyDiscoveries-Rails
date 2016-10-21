class RemoveTempImageForBase64ConvertionFromStories < ActiveRecord::Migration
  def change
    remove_column :stories, :temp_image_for_base64_convertion, :string
  end
end
