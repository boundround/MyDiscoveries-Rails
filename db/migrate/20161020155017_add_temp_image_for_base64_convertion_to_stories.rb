class AddTempImageForBase64ConvertionToStories < ActiveRecord::Migration
  def change
    add_column :stories, :temp_image_for_base64_convertion, :string
  end
end
